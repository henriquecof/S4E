/****** Object:  Procedure [dbo].[SP_PagamentoDentista_Convenio]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_PagamentoDentista_Convenio] @lote int 
as 
Begin
  Declare @id_convenio int 
  Declare @Sequencial int 

declare @t table(convenio int )
insert @t
   select distinct ans.IdConvenio 
     from Consultas as c inner join DEPENDENTES as d on c.cd_sequencial_dep = d.CD_SEQUENCIAL
	        inner join planos as p on d.cd_plano = p.cd_plano 
			inner join CLASSIFICACAO_ANS as ans on p.cd_classificacao = ans.cd_classificacao 
    where c.nr_numero_lote = @lote and 
          ans.IdConvenio is not null and
		  isnull(ans.IdConvenio,0) not in (select isnull(idConvenio_ans,0) from pagamento_dentista where CD_Sequencial = @lote) 
		  

declare @convenio integer = 0
declare @conta integer = 0

while (select count(0) from @t) >0
begin
    print '------------------------------------'
	set @conta = @conta + 1
	select top 1 
		@id_convenio = convenio
	from @t

	 
	  -- Gerar o novo lote  
	  Insert into Pagamento_Dentista (cd_centro_custo, cd_funcionario,dt_abertura, dt_fechamento, fl_fechado,cd_filial, data_corte, cd_modelo_pgto_prestador,usuario_abertura,fl_ExibicaoDetalhada, idConvenio_ans,
	          dt_protocolo,fl_importado,TipoLiberacaoVisualizacao,dt_liberacao_visualizacao,exibir,dt_competencia_pagamento,cd_filialOriginal,tipoFaturamento)   
	  select cd_centro_custo , cd_funcionario,dt_abertura, dt_fechamento,fl_fechado,cd_filial, data_corte, cd_modelo_pgto_prestador,usuario_abertura,fl_ExibicaoDetalhada,@id_convenio,
	         dt_protocolo,fl_importado,TipoLiberacaoVisualizacao,dt_liberacao_visualizacao,exibir,dt_competencia_pagamento,cd_filialOriginal,tipoFaturamento
	    from Pagamento_Dentista 
	   where CD_Sequencial = @lote
	  
	  Set @Sequencial = @@IDENTITY 

      -- Mover os procedimentos do lote anterior p o novo
	  update C        
	     set nr_numero_lote = @Sequencial 
		from Consultas as c inner join DEPENDENTES as d on c.cd_sequencial_dep = d.CD_SEQUENCIAL
				inner join planos as p on d.cd_plano = p.cd_plano 
				inner join CLASSIFICACAO_ANS as ans on p.cd_classificacao = ans.cd_classificacao 
		where c.nr_numero_lote = @lote and 
				ans.IdConvenio = @id_convenio
       
       -- Atualizar os totalizadores do novo lote        
	    update pagamento_dentista 
	       set qt_procedimentos = (select COUNT(0) from Consultas where nr_numero_lote=@Sequencial),
		       vl_parcela=(select SUM(vl_pago_produtividade) from Consultas where nr_numero_lote=@Sequencial)
	     where cd_sequencial=@Sequencial   

       -- Atualizar os totalizadores do lote anterior
	    update pagamento_dentista 
	       set qt_procedimentos = (select COUNT(0) from Consultas where nr_numero_lote=@lote),
		       vl_parcela=(select SUM(vl_pago_produtividade) from Consultas where nr_numero_lote=@lote)
	     where cd_sequencial=@lote  
		 
		 if (select qt_procedimentos from pagamento_dentista where cd_sequencial=@lote)=0
		 begin 
		    delete pagamento_dentista where cd_sequencial=@lote 
			print 'deletou lote'
		 end 	

	print @convenio
	delete @t where convenio = @id_convenio

	print 'Contador:'
	print @conta
end

End
