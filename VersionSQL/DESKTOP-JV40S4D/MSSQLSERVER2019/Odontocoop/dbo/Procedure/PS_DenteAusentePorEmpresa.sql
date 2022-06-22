/****** Object:  Procedure [dbo].[PS_DenteAusentePorEmpresa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_DenteAusentePorEmpresa](@Empresa int)
As
Begin

  Declare @NM_Empresa Varchar(100)
  Declare @CD_Quantidade1 int
  Declare @CD_Quantidade2 int
  Declare @CD_Quantidade3 int
  Declare @CD_Quantidade4 int
  Declare @CD_Quantidade5 int
  Declare @CD_Quantidade6 int
  Declare @CD_Quantidade7 int
  Declare @CD_Quantidade8 int
  Declare @CD_Quantidade9 int
  Declare @CD_Quantidade10 int
  Declare @CD_Quantidade11 int
  Declare @CD_Quantidade12 int
  Declare @CD_Quantidade13 int
  Declare @CD_Quantidade14 int
  Declare @CD_Quantidade15 int
  Declare @CD_Associado int
  Declare @CD_quantidade_Aux int
  Declare @CD_Sequencial int
  Declare @I int

  Create Table #Resultado
   (CD_Empresa int,
    nm_empresa varchar(100),
   CD_Quantidade1 int,
   CD_Quantidade2 int,
   CD_Quantidade3 int,
   CD_Quantidade4 int,
   CD_Quantidade5 int,
   CD_Quantidade6 int,
   CD_Quantidade7 int,
   CD_Quantidade8 int,
   CD_Quantidade9 int,
   CD_Quantidade10 int,
   CD_Quantidade11 int,
   CD_Quantidade12 int,
   CD_Quantidade13 int,
   CD_Quantidade14 int,
   CD_Quantidade15 int)

  Select @NM_Empresa = nm_empresa
    From TB_AssociadoDenteAusente 
    Where cd_empresa = @Empresa  

   set @CD_Quantidade1 = 0 
   set @CD_Quantidade2 = 0 
   set @CD_Quantidade3 = 0 
   set @CD_Quantidade4 = 0 
   set @CD_Quantidade5 = 0 
   set @CD_Quantidade6 = 0 
   set @CD_Quantidade7 = 0 
   set @CD_Quantidade8 = 0 
   set @CD_Quantidade9 = 0 
   set @CD_Quantidade10 = 0 
   set @CD_Quantidade11 = 0
   set @CD_Quantidade12 = 0
   set @CD_Quantidade13 = 0
   set @CD_Quantidade14 = 0
   set @CD_Quantidade15 = 0

   SEt @I = 1
   While @I <= 15
    Begin
       set @CD_Quantidade_Aux = 0

       If @I <= 14
         Begin
           Declare pessoas2_Cursor Cursor For
           Select  cd_associado,cd_sequencial
	   From TB_AssociadoDenteAusente 
	   Where cd_empresa = @empresa	              
	   Group By cd_associado,CD_Sequencial 
	   having count(cd_ud) = @I
          End
       Else
          Begin
           Declare pessoas2_Cursor Cursor For
           Select  cd_associado,cd_sequencial
	   From TB_AssociadoDenteAusente 
	   Where cd_empresa = @empresa	              
	   Group By cd_associado,CD_Sequencial 
	   having count(cd_ud) >= @I
          End

	  Open pessoas2_Cursor
	     Fetch next from pessoas2_Cursor
	     Into @CD_Associado,@CD_Sequencial

          While (@@fetch_status<>-1)
              Begin
                 set @CD_Quantidade_Aux = @CD_Quantidade_Aux + 1                 

        	 Fetch next from pessoas2_Cursor
	         Into @CD_Associado,@CD_Sequencial

              End       
           CLOSE      pessoas2_Cursor
           DEALLOCATE pessoas2_Cursor

           if @I = 1
              set @CD_Quantidade1 = @CD_Quantidade_Aux 

           if @I = 2
              set @CD_Quantidade2 = @CD_Quantidade_Aux           

           if @I = 3
              set @CD_Quantidade3 = @CD_Quantidade_Aux

           if @I = 4
              set @CD_Quantidade4 = @CD_Quantidade_Aux

           if @I = 5
              set @CD_Quantidade5 = @CD_Quantidade_Aux

           if @I = 6
              set @CD_Quantidade6 = @CD_Quantidade_Aux

           if @I = 7
              set @CD_Quantidade7 = @CD_Quantidade_Aux

           if @I = 8
              set @CD_Quantidade8 = @CD_Quantidade_Aux

           if @I = 9
              set @CD_Quantidade9 = @CD_Quantidade_Aux

           if @I = 10
              set @CD_Quantidade10 = @CD_Quantidade_Aux

           if @I = 11
              set @CD_Quantidade11 = @CD_Quantidade_Aux

           if @I = 12
              set @CD_Quantidade12 = @CD_Quantidade_Aux

            if @I = 13
              set @CD_Quantidade13 = @CD_Quantidade_Aux

            if @I = 14
              set @CD_Quantidade14 = @CD_Quantidade_Aux

            if @I = 15
              set @CD_Quantidade15 = @CD_Quantidade_Aux

             set @I = @I + 1

    End         

   Insert into #Resultado
   Select @empresa,@nm_empresa,                  
         @cd_quantidade1,@cd_quantidade2,@cd_quantidade3,
         @cd_quantidade4,@cd_quantidade5,@cd_quantidade6,
         @cd_quantidade7,@cd_quantidade8,@cd_quantidade9,
         @cd_quantidade10,@cd_quantidade11,@cd_quantidade12,
         @cd_quantidade13,@cd_quantidade14,@cd_quantidade15

   Select * From #Resultado

   Drop Table #Resultado
End
