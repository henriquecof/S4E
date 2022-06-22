/****** Object:  View [dbo].[VW_Procedimentos]    Committed by VersionSQL https://www.versionsql.com ******/

create view [dbo].[VW_Procedimentos] as
 select distinct
 T1.cd_sequencial, T1.cd_sequencial_dep, T1.cd_funcionario, T1.cd_servico, T1.cd_ud, dbo.FS_MostraFace(T1.cd_ud,T1.oclusal,T1.distral,T1.mesial,T1.vestibular,T1.lingual) faces, convert(varchar(10),T1.dt_servico,103) dt_servico, convert(varchar(10),T1.dt_pericia,103) dt_pericia, convert(varchar(10),T1.dt_baixa,103) + ' ' + convert(varchar(5),T1.dt_baixa,108) dt_baixa, convert(varchar(10),T1.dt_cancelamento,103) dt_cancelamento, T1.motivo_cancelamento, T1.usuario_cadastro, T1.usuario_baixa, T1.usuario_cancelamento, T1.vl_pago_produtividade, T1.cd_filial, T1.nr_autorizacao, T1.cd_sequencial_agenda, T1.nr_numero_lote, isnull(convert(int,T1.nr_procedimentoliberado),0) nr_procedimentoliberado, T1.cd_funcionarioAnalise, T1.nr_gto, T1.protocolo, T1.Status, T1.StatusInclusao, T1.cd_funcionario_solicitante, T1.vl_glosa, T1.rboId, convert(varchar(10),T1.dt_recebimento_protocolo,103) dt_recebimento_protocolo, T1.vl_acerto_pgto_produtividade, T1.id_protocolo, isnull(convert(int,T1.fl_urgencia),0) fl_urgenciaProcedimento, T1.OrdemRecebimentoProtocolo, convert(varchar(10),T1.DtImpressaoGTO,103) DtImpressaoGTO, T1.nr_gtoTISS, convert(varchar(10),T1.dt_analise,103) dt_analise, T1.vl_procedimento_cliente, T1.Chave, convert(varchar(10),T1.dt_bloqueado,103) dt_bloqueado, T1.vl_pago_manual, T1.odontograma, T1.ordemRealizacaoGTO, T1.cd_filial_Solicitante, T1.vl_franquia, T1.vl_coparticipacao, T1.ds_informacao_complementar, T1.dt_servico dt_servicoOrder, T1.dt_baixa dt_baixaOrder, T1.dt_cadastro dt_cadastroOrder, T1.dt_pericia dt_periciaOrder, case when T1.dt_analise is null then 0 else 1 end procedimentoAnalisado, isnull(convert(int,T1.fl_BaixaConjunto),0) fl_BaixaConjunto, T1.nomeSolicitanteLancamento, T1.CROSolicitanteLancamento, T1.porId, convert(varchar(50),T1.idIntegrador) idIntegrador, T1.nr_gtoPrestador, convert(varchar(10),T1.dt_pericia,103) + ' ' + convert(varchar(5),T1.dt_pericia,108) dt_periciaHora, convert(varchar(10),T1.dtPericiaFinal,103) + ' ' + convert(varchar(5),T1.dtPericiaFinal,108) dtPericiaFinal, T1.cd_funcionarioNotificacaoUpload, convert(varchar(10),T1.dataNotificacaoUpload,103) dataNotificacaoUpload, T1.cd_sequencialConsultaVinculado, convert(int,T1.permitirRealizacaoGlosado) permitirRealizacaoGlosado, T1.cd_sequencial_Exame,
 T2.nm_servico, T2.cd_especialidadereferencia, T2.cd_peso, isnull(convert(int,T2.fl_urgencia),0) fl_urgencia, isnull(convert(int,T2.fl_urgencia_noturna),0) fl_urgencia_noturna, T2.cd_servicoANS, T2.tp_procedimento, isnull(convert(int,T2.realizarAposLiberacaoManual),0) realizarAposLiberacaoManual, T2.cd_tipo_documentacao, isnull(convert(int,T2.fl_ContagemBaixaAgenda),0) fl_ContagemBaixaAgenda, isnull(convert(int,T2.realizacaoQualquerPrestador),0) realizacaoQualquerPrestador, isnull(convert(int,T2.cd_naoaceitapendente),0) cd_naoaceitapendente, isnull(convert(int,T2.baixarApenasAposUpload),0) baixarApenasAposUpload, isnull(T2.cd_tabelaANS,22) cd_tabelaANS, T2.qtDiasBloqueio, isnull(convert(int,T2.permiteDuplicadoGto),0) permiteDuplicadoGto, 
 T3.nm_empregado, T3.nr_cpf, T3.cro, T3.idCBOS, 
 T4.nm_filial, isnull(T4.tbcIdPendente,1) tbcIdPendente, isnull(T4.tbcIdRealizado,1) tbcIdRealizado, isnull(convert(int,T4.imprimir_vl_GTO),1) imprimir_vl_GTO, T4.alias_interno aliasClinica, T4.idGrupoClinica, T4.tipoRede, T4.cd_clinica, 
 T5.rboDescricao, T5.rboSigla, 
 T6.gorId, convert(varchar(10),T6.gloDtCadastro,103) gloDtCadastro, T6.gloGuiaExterna,
 T7.nm_dependente, T7.cd_associado, T7.cd_plano, T7.nr_carteira, 
 isnull(convert(int,T8.fl_exige_dentista),0) fl_exige_dentista, T8.nm_plano, 
 isnull(convert(int,T9.inicioContagemDiasCarencia),1) inicioContagemDiasCarencia, case when T34.nrANS is not null or T27.nr_ANS is not null then '' else T9.nome_site end nomeOperadoraGTO, 
 T10.nm_completo, 
 T11.tp_empresa, T11.cd_tabela cd_tabelaCoparticipacao, T11.nm_razsoc,
 Convert(varchar(10), t1.dt_cancelamento, 103) + ' ' + convert(varchar(10),t1.dt_cancelamento,108) as dataCancelamentoPT,
 t24.nm_empregado as EmpregadoCancelamento,
 T12.tipoPagamentoFranquia, T12.valorPagamentoFranquia, 
 T13.cd_pgto_dentista_lanc, 
 T14.Descricao StatusDescricao, 
 T15.cd_orcamento, isnull(T15.vl_servico,0) vl_orcamento, 
 T16.tipo TipoGlosa, T16.mglId, T16.Descricao_Glosa, T16.codigo_antigo_servico codigoProcedimentoAntigoGlosaParcial, T16.descricao_antigo_servico descricaoProcedimentoAntigoGlosaParcial, 
 T17.mglDescricao, 
 isnull(T18.foto_digitalizada,1) NecessidadeDocumentacao, T18.ds_motivo MotivoDocumentacao, 
 T19.vl_dominio ds_tipo_documentacao, 
 T22.nm_empregado nm_empregadoCadastro, T22.cro croEmpregadoCadastro, 
 T23.nm_empregado nm_empregadoBaixa, T23.cro croEmpregadoBaixa, 
 T24.nm_empregado nm_empregadoCancelamento, 
 T25.nm_empregado nm_empregadoAnalise, T25.cro croEmpregadoAnalise, 
 isnull(convert(int,T26.microCreditoAtivo),0) microCreditoAtivo, 
 case when T34.nrANS is not null then '' else isnull(T27.end_LogoMarca,'LogoSuperior.png') end end_LogoMarca, coalesce(T34.nrANS,T27.nr_ANS,T9.nr_ANS) nr_ANS, 
 T28.nm_empregado nm_empregadoSolicitante, T28.cro croSolicitante, T28.idCBOS idCBOSSolicitante, 
 T29.ufSigla uf_nm_empregado, 
 T30.ufSigla uf_nm_empregadoSolicitante, 
 T31.vl_dominio as classificacaoClinica, 
 CONVERT(varchar(10), T32.dt_conhecimento, 103) AS dt_conhecimento,
 T35.nm_empregado nm_empregadoPericiaFinal, T35.cro croEmpregadoPericiaFinal, 
 T36.nm_grau_parentesco,
 (select top 1 foto_digitalizada from tb_consultasdocumentacao where cd_sequencial = T1.cd_sequencial) Doc, 
 (select count(0) from plano_servico where cd_servico = T1.cd_servico and cd_plano = T7.cd_plano) procedimentoCoberto, 
 case when (T1.dt_servico is null and isnull(T12.id_coparticipacao,0) = 1) or (T1.dt_servico is not null and T1.vl_franquia is not null) then 1 else 0 end procedimentoCoparticipacao, 
 case when isnull(T13.exibir,1) = 1 then convert(varchar(10),case when T13.TipoLiberacaoVisualizacao = 1 then T13.dt_abertura when T13.TipoLiberacaoVisualizacao = 2 then case when (select count(0) from pagamento_dentista_lancamento where cd_pgto_dentista_lanc = T13.cd_pgto_dentista_lanc) > 0 then getdate() else null end when T13.TipoLiberacaoVisualizacao = 3 then case when (select count(0) from pagamento_dentista_lancamento where cd_pgto_dentista_lanc = T13.cd_pgto_dentista_lanc and sequencial_lancamento is not null) > 0 then getdate() else null end when T13.TipoLiberacaoVisualizacao = 4 then T13.dt_liberacao_visualizacao end,103) else null end dataInicioExibicaoPagamento, 
 case 
 	when isnull(T9.tsiId,1) = 2 or T1.dt_servico is not null or T1.dt_cancelamento is not null then 
 		'0' 
 	else 
       case 
 		    when T20.rcaPercentualCobertura is not null or T21.rcaPercentualCobertura is not null then 
 		        coalesce(convert(varchar,(select top 1 convert(int,convert(float,diasCarencia)*(convert(float, case when T20.rcaPercentualCobertura is not null then T20.rcaPercentualCobertura else T21.rcaPercentualCobertura end)/100)) from CarenciaPersonalizada where cd_sequencial_dep = T1.cd_sequencial_dep and isnull(cd_servico, T1.cd_servico) = T1.cd_servico and isnull(cd_especialidade, T2.cd_especialidadereferencia) = T2.cd_especialidadereferencia and dataExclusao is null and idGrupoCarencia is null)),convert(varchar,(select top 1 convert(int,convert(float,diasCarencia)*(convert(float, case when T20.rcaPercentualCobertura is not null then T20.rcaPercentualCobertura else T21.rcaPercentualCobertura end)/100)) from CarenciaPersonalizadaEmpresa X1 inner join associados X2 on X1.cd_empresa = X2.cd_empresa inner join dependentes X3 on X2.cd_associado = X3.cd_associado where X3.cd_sequencial = T1.cd_sequencial_dep and X1.DataInicial <= X3.dt_assinaturaContrato and isnull(X1.DataFinal,dateadd(year,50,getdate())) >= X3.dt_assinaturaContrato and isnull(X1.cd_plano, X3.cd_plano) = X3.cd_plano and isnull(X1.cd_especialidade, T2.cd_especialidadereferencia) = T2.cd_especialidadereferencia and isnull(X1.cd_servico, T1.cd_servico) = T1.cd_servico and case when X1.depid is null and X2.depid is null then 0 when X1.depid is not null then X1.depid else X2.depid end = isnull(X2.depid,0) and X1.DataExclusao is null and X1.idGrupoCarencia is null order by isnull(X1.DataFinal,dateadd(year,50,getdate())))),(select top 1 'DIASCARENCIAREFHOJE' + convert(varchar,datediff(day,getdate(),isnull(X1.dataInicioVigencia,T7.dt_assinaturaContrato)) + (convert(int,convert(float,X1.diasCarencia)*(convert(float, case when T20.rcaPercentualCobertura is not null then T20.rcaPercentualCobertura else T21.rcaPercentualCobertura end)/100)))) from CarenciaPersonalizada X1 inner join GrupoCarenciaProcedimento X2 on X2.idGrupoCarencia = X1.idGrupoCarencia inner join GrupoCarencia X3 on X3.idGrupoCarencia = X2.idGrupoCarencia where X1.cd_sequencial_dep = T1.cd_sequencial_dep and X2.cd_servico = T1.cd_servico and X1.dataExclusao is null and X2.dataExclusao is null and X3.dataExclusao is null),convert(varchar,(select top 1 convert(int,convert(float,qt_diascarencia)*(convert(float, case when T20.rcaPercentualCobertura is not null then T20.rcaPercentualCobertura else T21.rcaPercentualCobertura end)/100)) from plano_servico where cd_plano = T7.cd_plano and cd_servico = T1.cd_servico)),'0') 
 		    else 
 		        coalesce(convert(varchar,(select top 1 diasCarencia from CarenciaPersonalizada where cd_sequencial_dep = T1.cd_sequencial_dep and isnull(cd_servico, T1.cd_servico) = T1.cd_servico and isnull(cd_especialidade, T2.cd_especialidadereferencia) = T2.cd_especialidadereferencia and dataExclusao is null and idGrupoCarencia is null)),convert(varchar,(select top 1 DiasCarencia from CarenciaPersonalizadaEmpresa X1 inner join associados X2 on X1.cd_empresa = X2.cd_empresa inner join dependentes X3 on X2.cd_associado = X3.cd_associado where X3.cd_sequencial = T1.cd_sequencial_dep and X1.DataInicial <= X3.dt_assinaturaContrato and isnull(X1.DataFinal,dateadd(year,50,getdate())) >= X3.dt_assinaturaContrato and isnull(X1.cd_plano, X3.cd_plano) = X3.cd_plano and isnull(X1.cd_especialidade, T2.cd_especialidadereferencia) = T2.cd_especialidadereferencia and isnull(X1.cd_servico, T1.cd_servico) = T1.cd_servico and case when X1.depid is null and X2.depid is null then 0 when X1.depid is not null then X1.depid else X2.depid end = isnull(X2.depid,0) and X1.DataExclusao is null and X1.idGrupoCarencia is null order by isnull(X1.DataFinal,dateadd(year,50,getdate())))),(select top 1 'DIASCARENCIAREFHOJE' + convert(varchar,datediff(day,getdate(),isnull(X1.dataInicioVigencia,T7.dt_assinaturaContrato)) + X1.diasCarencia) from CarenciaPersonalizada X1 inner join GrupoCarenciaProcedimento X2 on X2.idGrupoCarencia = X1.idGrupoCarencia inner join GrupoCarencia X3 on X3.idGrupoCarencia = X2.idGrupoCarencia where X1.cd_sequencial_dep = T1.cd_sequencial_dep and X2.cd_servico = T1.cd_servico and X1.dataExclusao is null and X2.dataExclusao is null and X3.dataExclusao is null),convert(varchar,(select top 1 qt_diascarencia from plano_servico where cd_plano = T7.cd_plano and cd_servico = T1.cd_servico)),'0') 
 		    end 
   end 
 qt_diascarencia, 
 case when T1.status = 5 then (select top 1 ds_erro from inconsistencia_consulta where cd_sequencial_consulta = T1.cd_sequencial order by cd_sequencial desc) else null end ds_erro, 
 (select count(0) from ArquivoConsultas where cd_sequencial = T1.cd_sequencial and arcDtExclusao is null) QtdeImagemUpload, 
 (select count(0) from plano_servico where cd_plano = T7.cd_plano and cd_servico = T1.cd_servico and fl_exclusivo = 1) fl_exclusivo, 
 (select count(0) from EstornoPagamentoPrestador where cd_sequencialConsulta = T1.cd_sequencial and dataExclusao is null) as estornoPagamento, 
 convert(varchar(10),coalesce((select top 1 case when Tipo_ContaLancamento = 1 then Data_Pagamento else Data_Documento end from Tb_formaLancamento where sequencial_lancamento = T32.sequencial_lancamento), T13.dt_pagamento, T13.dt_previsao_pagamento),103) dataPagamento, CONVERT(varchar(10), COALESCE
                          ((SELECT     TOP (1) Data_Documento
                              FROM         dbo.TB_FormaLancamento AS TB_FormaLancamento_2
                              WHERE     (Sequencial_Lancamento = T32.sequencial_lancamento) AND (Tipo_ContaLancamento <> 1)), T13.dt_previsao_pagamento), 103) AS dataPrevisaoPagamentoReal, 
                      CONVERT(varchar(10), COALESCE
                          ((SELECT     TOP (1) Data_Lancamento
                              FROM         dbo.TB_FormaLancamento AS TB_FormaLancamento_1
                              WHERE     (Sequencial_Lancamento = T32.sequencial_lancamento) AND (Tipo_ContaLancamento = 1)), T13.dt_pagamento), 103) AS dataPagamentoReal,
 (select replace((select distinct cd_especialidade as 'data()' from ServicoEspecialidade where cd_servico = T1.cd_servico order by cd_especialidade For XML PATH ('')),' ',',')) especialidadeNecessaria, 
 isnull( 
 case 
 when T1.status = 7 and T16.Tipo = 2 then 
   0 
 when T1.dt_servico is not null and T1.nr_numero_lote is not null then 
   isnull(T1.vl_pago_produtividade,0) 
 when T1.vl_pago_manual is not null then 
   T1.vl_pago_manual 
 when (select count(0) from plano_servico where cd_servico = T1.cd_servico and cd_plano = T7.cd_plano) > 0 or T1.status = 6 or T9.incluirProcPartProdutividade = 1 then 
   case 
       when isnull(T9.RefAtualizacaoTabelaDentista,1) = 1 then 
           (select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 or isnull(T9.TipoValorCalculoProdutividadeDentista,1) = 1 then 1 else T2.vl_us end,2) from tabela_servicos TT1 inner join tabela_referencia TT2 on TT1.cd_tabela_referencia = TT2.cd_tabela_referencia where TT1.cd_tabela =  Case When isnull(T9.LocalTabelaPagamentoDentista,1) = 1 Then T3.cd_tabela Else T4.cd_tabela End  and isnull(TT1.cd_servico,T2.cd_servico) = T2.cd_servico and isnull(TT1.cd_plano,T7.cd_plano) = T7.cd_plano and isnull(TT1.cd_especialidade,T2.cd_especialidadereferencia) = T2.cd_especialidadereferencia order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc, TT1.cd_plano desc, TT1.cd_servico desc, TT1.cd_especialidade desc) 
       when T9.RefAtualizacaoTabelaDentista = 2 then 
           (select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 or isnull(T9.TipoValorCalculoProdutividadeDentista,1) = 1 then 1 else T2.vl_us end,2) from tabela_servicos TT1 inner join tabela_referencia TT2 on TT1.cd_tabela_referencia = TT2.cd_tabela_referencia where TT1.cd_tabela =  Case When isnull(T9.LocalTabelaPagamentoDentista,1) = 1 Then T3.cd_tabela Else T4.cd_tabela End  and isnull(TT1.cd_servico,T2.cd_servico) = T2.cd_servico and isnull(TT1.cd_plano,T7.cd_plano) = T7.cd_plano and isnull(TT1.cd_especialidade,T2.cd_especialidadereferencia) = T2.cd_especialidadereferencia and convert(date,isnull(T1.dt_servico,getdate())) >= TT2.dt_inicio and convert(date,isnull(T1.dt_servico,getdate())) <= isnull(TT2.dt_fim,getdate()) order by TT1.cd_plano desc, TT1.cd_servico desc, TT1.cd_especialidade desc) 
       when T9.RefAtualizacaoTabelaDentista = 3 then 
           (select top 1 round(case when TF2.tipoValor = 2 then TF2.valor else TF1.vl_servico * case when TF1.tipoMoedaCalculo = 2 then 1 else TF2.valor end end, 2) from tabela_servicos TF1, tabela_fator TF2 where TF1.cd_tabela =  case when T9.LocalTabelaPagamentoDentista = 1 then T3.cd_tabela else T4.cd_tabela end  and TF1.cd_servico = T2.cd_servico and isnull(TF2.cd_servico,TF1.cd_servico) = T2.cd_servico and coalesce(TF2.cd_plano,TF1.cd_plano,T7.cd_plano) = T7.cd_plano and isnull(TF1.cd_plano,T7.cd_plano) = isnull(TF2.cd_plano,T7.cd_plano) and isnull(TF2.cd_especialidade,T2.cd_especialidadereferencia) = T2.cd_especialidadereferencia and case when T9.LocalTabelaPagamentoDentista = 1 then TF2.cd_funcionario else TF2.cd_filial end = case when T9.LocalTabelaPagamentoDentista = 1 then T1.cd_funcionario else T1.cd_filial end and convert(date,isnull(T1.dt_servico,getdate())) >= TF2.dataInicial and convert(date,isnull(T1.dt_servico,getdate())) <= isnull(TF2.dataFinal,getdate()) and TF2.dataExclusao is null order by TF2.cd_plano desc, TF1.cd_plano desc, TF2.cd_servico desc, TF2.cd_especialidade desc) 
   end 
 end 
 ,0) vl_servico_Clinico,
  isnull( 
 case 
 when (select count(0) from plano_servico where cd_servico = T1.cd_servico and cd_plano = T7.cd_plano) > 0 or T1.status = 6 or T9.incluirProcPartProdutividade = 1 then 
   case 
       when isnull(T9.RefAtualizacaoTabelaDentista,1) = 1 then 
           (select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 or isnull(T9.TipoValorCalculoProdutividadeDentista,1) = 1 then 1 else T2.vl_us end,2) from tabela_servicos TT1 inner join tabela_referencia TT2 on TT1.cd_tabela_referencia = TT2.cd_tabela_referencia where TT1.cd_tabela =  Case When isnull(T9.LocalTabelaPagamentoDentista,1) = 1 Then T3.cd_tabela Else T4.cd_tabela End  and isnull(TT1.cd_servico,T2.cd_servico) = T2.cd_servico and isnull(TT1.cd_plano,T7.cd_plano) = T7.cd_plano and isnull(TT1.cd_especialidade,T2.cd_especialidadereferencia) = T2.cd_especialidadereferencia order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc, TT1.cd_plano desc, TT1.cd_servico desc, TT1.cd_especialidade desc) 
       when T9.RefAtualizacaoTabelaDentista = 2 then 
           (select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 or isnull(T9.TipoValorCalculoProdutividadeDentista,1) = 1 then 1 else T2.vl_us end,2) from tabela_servicos TT1 inner join tabela_referencia TT2 on TT1.cd_tabela_referencia = TT2.cd_tabela_referencia where TT1.cd_tabela =  Case When isnull(T9.LocalTabelaPagamentoDentista,1) = 1 Then T3.cd_tabela Else T4.cd_tabela End  and isnull(TT1.cd_servico,T2.cd_servico) = T2.cd_servico and isnull(TT1.cd_plano,T7.cd_plano) = T7.cd_plano and isnull(TT1.cd_especialidade,T2.cd_especialidadereferencia) = T2.cd_especialidadereferencia and convert(date,isnull(T1.dt_servico,getdate())) >= TT2.dt_inicio and convert(date,isnull(T1.dt_servico,getdate())) <= isnull(TT2.dt_fim,getdate()) order by TT1.cd_plano desc, TT1.cd_servico desc, TT1.cd_especialidade desc) 
       when T9.RefAtualizacaoTabelaDentista = 3 then 
           (select top 1 round(case when TF2.tipoValor = 2 then TF2.valor else TF1.vl_servico * case when TF1.tipoMoedaCalculo = 2 then 1 else TF2.valor end end, 2) from tabela_servicos TF1, tabela_fator TF2 where TF1.cd_tabela =  case when T9.LocalTabelaPagamentoDentista = 1 then T3.cd_tabela else T4.cd_tabela end  and TF1.cd_servico = T2.cd_servico and isnull(TF2.cd_servico,TF1.cd_servico) = T2.cd_servico and coalesce(TF2.cd_plano,TF1.cd_plano,T7.cd_plano) = T7.cd_plano and isnull(TF1.cd_plano,T7.cd_plano) = isnull(TF2.cd_plano,T7.cd_plano) and isnull(TF2.cd_especialidade,T2.cd_especialidadereferencia) = T2.cd_especialidadereferencia and case when T9.LocalTabelaPagamentoDentista = 1 then TF2.cd_funcionario else TF2.cd_filial end = case when T9.LocalTabelaPagamentoDentista = 1 then T1.cd_funcionario else T1.cd_filial end and convert(date,isnull(T1.dt_servico,getdate())) >= TF2.dataInicial and convert(date,isnull(T1.dt_servico,getdate())) <= isnull(TF2.dataFinal,getdate()) and TF2.dataExclusao is null order by TF2.cd_plano desc, TF1.cd_plano desc, TF2.cd_servico desc, TF2.cd_especialidade desc) 
   end 
 end 
 ,0) vl_conhecido
 , isnull(convert(int,c.abrangenciaCreditoOrcamento),1) abrangenciaCreditoOrcamento 
 , isnull(t4.GTODigital,0) as GTODigital 
 , isnull(convert(int,T8.usaCreditoBaixaOrto),1) usaCreditoBaixaOrto,
 (select count(0) from consultas where nr_gto = T1.nr_gto and dt_cancelamento is null) qtdeProcedimentosGTO
 from consultas T1 
 inner join servico T2 on T1.cd_servico = T2.cd_servico 
 left join funcionario T3 on T1.cd_funcionario = T3.cd_funcionario 
 inner join filial T4 on T1.cd_filial = T4.cd_filial 
 left join RegiaoBoca T5 on T1.rboId = T5.rboId 
 left join GTOLote T6 on T1.nr_gto = T6.gloGTO 
 inner join dependentes T7 on T1.cd_sequencial_dep = T7.cd_sequencial 
 inner join planos T8 on T7.cd_plano = T8.cd_plano 
 inner join Configuracao T9 on 1 = 1 
 inner join associados T10 on T7.cd_associado = T10.cd_associado 
 inner join empresa T11 on T10.cd_empresa = T11.cd_empresa 
 left join plano_servico T12 on T8.cd_plano = T12.cd_plano and T1.cd_servico = T12.cd_servico 
 left join pagamento_dentista T13 on T1.nr_numero_lote = T13.cd_sequencial 
 inner join consultas_status T14 on T1.status = T14.status 
 left join orcamento_servico T15 on T1.cd_sequencial = T15.cd_sequencial_pp 
 left join tb_consultasglosados T16 on T1.cd_sequencial = T16.cd_sequencial 
 left join MotivoGlosa T17 on T16.mglId = T17.mglId 
 left join TB_ConsultasDocumentacao T18 on T1.cd_sequencial = T18.cd_sequencial 
 left join Dominio_valor T19 on T2.cd_tipo_documentacao = T19.cd_sequencial and cd_dominio = 61 
 left join RegraCarenciaAtendimento T20 On T7.rcaId = T20.rcaId 
 left join RegraCarenciaAtendimento T21 On T11.rcaId = T21.rcaId 
 left join funcionario T22 On T1.usuario_cadastro = T22.cd_funcionario 
 left join funcionario T23 On T1.usuario_baixa = T23.cd_funcionario 
 left join funcionario T24 On T1.usuario_cancelamento = T24.cd_funcionario 
 left join funcionario T25 On T1.cd_funcionarioAnalise = T25.cd_funcionario 
 left join orcamento_clinico T26 on T15.cd_orcamento = T26.cd_orcamento 
 inner join centro_custo T27 on T11.cd_centro_custo = T27.cd_centro_custo 
 left join funcionario T28 on T1.cd_funcionario_solicitante = T28.cd_funcionario 
 left join uf T29 on T3.ufId = T29.ufId 
 left join uf T30 on T28.ufId = T30.ufId 
 left join Dominio_valor T31 on T4.classificacaoFilialDominio = T31.cd_sequencial and T31.cd_dominio = 57 
 left join Pagamento_Dentista_Lancamento T32 on T13.cd_pgto_dentista_lanc = T32.cd_pgto_dentista_lanc 
 left join classificacao_ans T33 on T33.cd_classificacao = T8.cd_classificacao 
 left join convenio T34 on T34.id = T33.idConvenio 
 left join funcionario T35 On T1.cd_funcionarioPericiaFinal = T35.cd_funcionario 
 Left Join centro_custo c on t26.cd_centro_custo = c.cd_centro_custo 
 left join grau_parentesco T36 on T36.cd_grau_parentesco = T7.cd_grau_parentesco
