/****** Object:  Table [dbo].[HistoricoAlteracaoPlano]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[HistoricoAlteracaoPlano](
	[cd_historico] [int] IDENTITY(1,1) NOT NULL,
	[cd_dependente] [int] NULL,
	[cd_plano_anterior] [int] NULL,
	[cd_plano_novo] [int] NULL,
	[dt_solicitacao] [datetime] NULL,
	[cd_funcionario_cadastro] [int] NULL,
	[cd_funcionario_alteracao] [int] NULL,
	[cd_funcionario_exclusao] [int] NULL,
	[fl_realizado] [bit] NULL,
	[dt_alteracao] [datetime] NULL,
	[dt_mudanca] [datetime] NULL,
	[dt_realizacao] [datetime] NULL,
	[cd_empresaOrigem] [bigint] NULL,
	[cd_empresaDestino] [bigint] NULL,
	[flAtualizarValor] [bit] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[HistoricoAlteracaoPlano]  WITH CHECK ADD  CONSTRAINT [FK_Dependente_HistoricoAlteracaoPlano] FOREIGN KEY([cd_dependente])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[HistoricoAlteracaoPlano] CHECK CONSTRAINT [FK_Dependente_HistoricoAlteracaoPlano]
ALTER TABLE [dbo].[HistoricoAlteracaoPlano]  WITH CHECK ADD  CONSTRAINT [FK_HistoricoAlteracaoPlano_EMPRESA] FOREIGN KEY([cd_empresaDestino])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[HistoricoAlteracaoPlano] CHECK CONSTRAINT [FK_HistoricoAlteracaoPlano_EMPRESA]
ALTER TABLE [dbo].[HistoricoAlteracaoPlano]  WITH CHECK ADD  CONSTRAINT [FK_HistoricoAlteracaoPlano_EMPRESA1] FOREIGN KEY([cd_empresaOrigem])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[HistoricoAlteracaoPlano] CHECK CONSTRAINT [FK_HistoricoAlteracaoPlano_EMPRESA1]
ALTER TABLE [dbo].[HistoricoAlteracaoPlano]  WITH CHECK ADD  CONSTRAINT [FK_Planos_HistoricoAlteracaoPlano_Anterior] FOREIGN KEY([cd_plano_anterior])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[HistoricoAlteracaoPlano] CHECK CONSTRAINT [FK_Planos_HistoricoAlteracaoPlano_Anterior]
ALTER TABLE [dbo].[HistoricoAlteracaoPlano]  WITH CHECK ADD  CONSTRAINT [FK_Planos_HistoricoAlteracaoPlano_Novo] FOREIGN KEY([cd_plano_novo])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[HistoricoAlteracaoPlano] CHECK CONSTRAINT [FK_Planos_HistoricoAlteracaoPlano_Novo]
