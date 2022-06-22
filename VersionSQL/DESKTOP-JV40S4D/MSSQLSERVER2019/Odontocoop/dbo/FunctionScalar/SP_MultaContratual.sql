/****** Object:  Function [dbo].[SP_MultaContratual]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[SP_MultaContratual](@sequencial int) RETURNS Money
as
Begin

   Declare @vigencia int 
   Declare @valor money 
   Declare @qtde_meses int 
   Declare @tp_empresa int
   Declare @cd_associado_empresa int 
   Declare @cd_grau_parent int 
   Declare @total money = 0 
   
   Select @vigencia = e.qt_vigencia, @cd_grau_parent = d.cd_grau_parentesco , 
          @tp_empresa = e.tp_empresa ,
          @cd_associado_empresa= case when e.tp_empresa in (2,6,8) then e.cd_empresa else a.cd_associado end 
     from DEPENDENTES as d, ASSOCIADOS as a, EMPRESA as e
    where d.CD_ASSOCIADO = a.cd_associado 
      and a.cd_empresa = e.CD_EMPRESA 
      and d.CD_SEQUENCIAL = @sequencial 
      
    if @cd_grau_parent=1 
    begin
		Declare cursor_multa CURSOR FOR  
		select d.cd_sequencial, d.vl_plano 
		  from dependentes as d, historico as h
		 where d.cd_Associado in (select cd_associado from dependentes where cd_sequencial = @sequencial) and 
		       d.cd_sequencial_historico = h.cd_sequencial and 
		       h.cd_situacao not in (2,3,16)
	end
	else
	begin
	    Declare cursor_multa CURSOR FOR  
		select d.cd_sequencial, d.vl_plano 
		  from dependentes as d, historico as h
		 where d.cd_sequencial = @sequencial and 
		       d.cd_sequencial_historico = h.cd_sequencial and 
		       h.cd_situacao not in (2,3,16)
	End	
	open cursor_multa
    fetch next from cursor_multa into @sequencial, @valor
    while (@@fetch_status<>-1)
    begin
		   Select @qtde_meses = count(0) 
			 from mensalidades as m , mensalidades_planos as mp 
			where m.cd_parcela = mp.cd_parcela_mensalidade 
			  and mp.cd_sequencial_dep = @sequencial 
			  and mp.cd_tipo_parcela = 1 
			  and mp.dt_exclusao is null 
			  and m.cd_tipo_recebimento not in (1,2)
			  and m.tp_Associado_empresa in ( case when @tp_empresa in (2,6,8) then 2 else 1 end)
			  and m.cd_associado_empresa = @cd_associado_empresa
		      
		   if @qtde_meses < @vigencia
			  Set @total= @total + ((@valor * 0.2)*(@vigencia-@qtde_meses))
 
 
       fetch next from cursor_multa into @sequencial, @valor
    End        
    
    Return @total
    
End 
