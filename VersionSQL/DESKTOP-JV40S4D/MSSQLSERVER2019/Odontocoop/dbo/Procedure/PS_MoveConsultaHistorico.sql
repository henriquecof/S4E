/****** Object:  Procedure [dbo].[PS_MoveConsultaHistorico]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Criado por Marcio Nogueira Costa
Data : 07/05/2008
Objetivo : Mover os registros da tabela de consultas(DT_Cancelamento is not null) que se encontram no servidor RAIZ 
           para a tabela consultas_historico que se encontra no servidor DENTE.
           Apagar depois os os registros da tabela de consultas(DT_Cancelamento is not null) que se encontram no servidor RAIZ. 
*/
CREATE Procedure [dbo].[PS_MoveConsultaHistorico]
As
Begin

   Insert into [DENTE].ABS_Historico.dbo.consultas_historico (
           cd_sequencial,cd_associado,cd_sequencial_dep,dt_servico,
           dt_pericia,cd_servico,dt_baixa,motivo_cancelamento,CD_FUNCIONARIO,
           cd_UD,oclusal,distral,mesial,vestibular,lingual,cd_filial,nr_autorizacao,
           cd_sequencial_agenda,nr_guia,fl_foto,fl_analisa,cd_clinica,
           dt_operacao,nr_operacao,ds_informacao_complementar,
           usuario_cadastro,usuario_baixa,usuario_guia)
   Select  cd_sequencial,cd_associado,cd_sequencial_dep,dt_servico,
           dt_pericia,cd_servico,dt_baixa,motivo_cancelamento,CD_FUNCIONARIO,
           cd_UD,oclusal,distral,mesial,vestibular,lingual,cd_filial,nr_autorizacao,
           cd_sequencial_agenda,nr_guia,fl_foto,fl_analisa,cd_clinica,
           dt_cancelamento,2,ds_informacao_complementar,
           usuario_cadastro,usuario_baixa,usuario_guia
   From Consultas
   Where dt_cancelamento is not null  And
         cd_sequencial not in (select cd_sequencial_pp
                            From pagamento_dentista_guia)   



   Delete From Consultas
   Where dt_cancelamento is not null And
     cd_sequencial not in (select cd_sequencial_pp
                            From pagamento_dentista_guia)  And
    cd_sequencial not in (select cd_sequencial
                            From   TB_ConsultasDocumentacao) 


End 
