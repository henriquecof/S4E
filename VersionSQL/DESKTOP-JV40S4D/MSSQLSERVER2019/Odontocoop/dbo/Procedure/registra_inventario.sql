/****** Object:  Procedure [dbo].[registra_inventario]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[registra_inventario](@CD_PRODUTO AS INT,@QT_inv AS float,@CD_FILIAL AS INT,@CD_GRUPO AS INT,@NOME_USUARIO AS VARCHAR(20))
AS
DECLARE @QT_est AS float,
	@cd_inventario as int,
	@fl_inv as bit

select @cd_inventario=cd_inventario 
from inventario 
where cd_filial = @CD_FILIAL and 
      cd_grupo =@CD_GRUPO

if @cd_inventario<>''
   Begin

	Update produtos_inventario set 
           qt_produto = @QT_inv, 
           NOME_USUARIO = @NOME_USUARIO 
    Where cd_inventario = @cd_inventario and 
          cd_produto = @CD_PRODUTO

	if (select count(cd_inventario) from movimento_inventario 
          where cd_inventario = @cd_inventario and 
                cd_produto = @CD_PRODUTO) <>0
	  begin
             update movimento_inventario 
                  set nome_usuario = @NOME_USUARIO 
                  where cd_inventario = @cd_inventario and 
                        cd_produto = @CD_PRODUTO

	         delete from movimento_inventario 
                 where cd_inventario = @cd_inventario and 
                       cd_produto = @CD_PRODUTO
	  end

	  select @QT_est=isnull(qt_estoque,0) 
             from estoque   
             where cd_filial = @CD_FILIAL and 
                   cd_produto =@cd_produto
  
	  If @QT_est <> @QT_inv
	     Begin
		  if @QT_est < @QT_inv
		    begin 
	       		set @fl_inv = 1			
		    end
 
	      if @QT_est > @QT_inv
		    begin
	        	set @fl_inv = 0
      	    End

           insert into movimento_inventario
                  (cd_inventario,cd_produto,QUANTIDADE,MOVIMENTO,nome_usuario)
           values
                  (@cd_inventario,@CD_PRODUTO,abs(@QT_est - @QT_inv),@fl_inv,@nome_usuario)
          End 
       Else
	     Begin		  
       		set @fl_inv = 0				
                insert into movimento_inventario(cd_inventario,cd_produto,QUANTIDADE,MOVIMENTO,nome_usuario)
	          values(@cd_inventario,@CD_PRODUTO,abs(@QT_est - @QT_inv),@fl_inv,@nome_usuario)
         End 

   End
