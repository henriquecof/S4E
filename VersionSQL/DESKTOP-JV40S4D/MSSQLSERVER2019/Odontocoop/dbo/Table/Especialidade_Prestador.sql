/****** Object:  Table [dbo].[Especialidade_Prestador]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Especialidade_Prestador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_filial] [int] NULL,
	[cd_especialidade] [int] NOT NULL,
	[cd_funcionario] [int] NULL,
	[cd_atuacao_dentista] [int] NULL,
	[cd_usuario] [int] NULL,
	[dt_usuario] [datetime] NULL,
	[dt_usuarioExclusao] [datetime] NULL,
	[dt_descredenciamento] [datetime] NULL,
	[dt_inicioSubstituicao] [datetime] NULL,
	[cd_usuarioExclusao] [int] NULL,
	[cd_filialSubstituta] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[Especialidade_Prestador]  WITH CHECK ADD  CONSTRAINT [FK_Especialidade_Prestador_atuacao_dentista] FOREIGN KEY([cd_atuacao_dentista])
REFERENCES [dbo].[atuacao_dentista] ([cd_sequencial])
ALTER TABLE [dbo].[Especialidade_Prestador] CHECK CONSTRAINT [FK_Especialidade_Prestador_atuacao_dentista]
ALTER TABLE [dbo].[Especialidade_Prestador]  WITH CHECK ADD  CONSTRAINT [FK_Especialidade_Prestador_ESPECIALIDADE] FOREIGN KEY([cd_especialidade])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[Especialidade_Prestador] CHECK CONSTRAINT [FK_Especialidade_Prestador_ESPECIALIDADE]
ALTER TABLE [dbo].[Especialidade_Prestador]  WITH CHECK ADD  CONSTRAINT [FK_Especialidade_Prestador_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[Especialidade_Prestador] CHECK CONSTRAINT [FK_Especialidade_Prestador_FILIAL]
ALTER TABLE [dbo].[Especialidade_Prestador]  WITH CHECK ADD  CONSTRAINT [FK_Especialidade_Prestador_FILIAL1] FOREIGN KEY([cd_filialSubstituta])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[Especialidade_Prestador] CHECK CONSTRAINT [FK_Especialidade_Prestador_FILIAL1]
