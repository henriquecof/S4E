/****** Object:  Table [dbo].[funcionario_especialidade_dente]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[funcionario_especialidade_dente](
	[cd_funcionario] [int] NULL,
	[cd_especialidade] [int] NULL,
	[dente] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[funcionario_especialidade_dente]  WITH CHECK ADD  CONSTRAINT [FK_especialidade_cd_especialidade_] FOREIGN KEY([cd_especialidade])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[funcionario_especialidade_dente] CHECK CONSTRAINT [FK_especialidade_cd_especialidade_]
ALTER TABLE [dbo].[funcionario_especialidade_dente]  WITH CHECK ADD  CONSTRAINT [FK_funcionario_cd_funcionario_] FOREIGN KEY([cd_funcionario])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[funcionario_especialidade_dente] CHECK CONSTRAINT [FK_funcionario_cd_funcionario_]
