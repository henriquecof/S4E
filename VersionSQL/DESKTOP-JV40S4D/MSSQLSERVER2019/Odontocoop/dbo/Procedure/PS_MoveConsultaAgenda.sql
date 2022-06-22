/****** Object:  Procedure [dbo].[PS_MoveConsultaAgenda]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Criado por Marcio Nogueira Costa
Data : 07/05/2008
Objetivo : Mover os registros da tabela de consultas(DT_Cancelamento is not null) que se encontram no servidor RAIZ 
           para a tabela consultas_historico que se encontra no servidor DENTE.
           Apagar depois os os registros da tabela de consultas(DT_Cancelamento is not null) que se encontram no servidor RAIZ. 
*/
CREATE Procedure [dbo].[PS_MoveConsultaAgenda]
As
Begin

             Insert into [DENTE].ABS_Historico.dbo.agenda_historico
			(cd_sequencial,dt_compromisso,cd_funcionario,
			 hr_compromisso,cd_associado,cd_sequencial_dep,
			 cd_usuario,
             cd_empresa,nr_autorizacao,fl_urgencia,
			 cd_sequencial_atuacao_dent,nm_motivoatendimento)
			Select 
			 cd_sequencial,dt_compromisso,cd_funcionario,
			 hr_compromisso,cd_associado,cd_sequencial_dep,
			 cd_usuario,
             cd_empresa,nr_autorizacao,fl_urgencia,
			 cd_sequencial_atuacao_dent,nm_motivoatendimento
             From agenda_historico   

             Delete From agenda_historico   
End 
