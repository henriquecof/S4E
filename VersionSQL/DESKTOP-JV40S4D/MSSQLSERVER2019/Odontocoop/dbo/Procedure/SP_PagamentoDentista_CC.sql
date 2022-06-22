/****** Object:  Procedure [dbo].[SP_PagamentoDentista_CC]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_PagamentoDentista_CC] @lote int 
as 
Begin
  Declare @cd_centrocusto int 
  Declare @Sequencial int 
  Declare Cursor_PDCC Cursor For 
   select distinct e.cd_centro_custo
     from Consultas as c, DEPENDENTES as d, ASSOCIADOS as a, EMPRESA as e 
    where c.nr_numero_lote = @lote and 
          c.cd_sequencial_dep = d.CD_SEQUENCIAL and
          d.CD_ASSOCIADO = a.cd_associado and 
          a.cd_empresa = e.CD_EMPRESA and 
          e.cd_centro_custo not in (select cd_centro_custo from pagamento_dentista where CD_Sequencial = @lote) 
	Open Cursor_PDCC  
	Fetch next from Cursor_PDCC Into @cd_centrocusto
	Begin 
	   
	  -- Gerar o novo lote  
	  Insert into Pagamento_Dentista (cd_centro_custo, cd_funcionario,dt_abertura, dt_fechamento, fl_fechado,cd_filial, data_corte, cd_modelo_pgto_prestador,usuario_abertura,fl_ExibicaoDetalhada,
	         dt_protocolo,fl_importado,TipoLiberacaoVisualizacao,dt_liberacao_visualizacao,exibir,dt_competencia_pagamento,cd_filialOriginal,tipoFaturamento)   
	  select @cd_centrocusto , cd_funcionario,dt_abertura, dt_fechamento,fl_fechado,cd_filial, data_corte, cd_modelo_pgto_prestador,usuario_abertura,fl_ExibicaoDetalhada,
	         dt_protocolo,fl_importado,TipoLiberacaoVisualizacao,dt_liberacao_visualizacao,exibir,dt_competencia_pagamento,cd_filialOriginal,tipoFaturamento 
	    from Pagamento_Dentista 
	   where CD_Sequencial = @lote
	  
	  Set @Sequencial = @@IDENTITY 

      -- Mover os procedimentos do lote anterior p o novo
	  update Consultas        
	     set nr_numero_lote = @Sequencial 
	    from DEPENDENTES as d, ASSOCIADOS as a, EMPRESA as e
	   where nr_numero_lote =@lote and
	  	     Consultas.cd_sequencial_dep = d.CD_SEQUENCIAL and
             d.CD_ASSOCIADO = a.cd_associado and 
             a.cd_empresa = e.CD_EMPRESA and 
             e.cd_centro_custo = @cd_centrocusto
       
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
		 end 	
	
	   Fetch next from Cursor_PDCC Into @cd_centrocusto
	End 
    Close Cursor_PDCC
    Deallocate Cursor_PDCC
    


End
