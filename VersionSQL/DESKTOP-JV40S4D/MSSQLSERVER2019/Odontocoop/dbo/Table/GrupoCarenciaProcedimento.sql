/****** Object:  Table [dbo].[GrupoCarenciaProcedimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoCarenciaProcedimento](
	[idGrupoCarenciaProcedimento] [int] IDENTITY(1,1) NOT NULL,
	[idGrupoCarencia] [int] NOT NULL,
	[cd_servico] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
 CONSTRAINT [PK_GrupoCarenciaProcedimento] PRIMARY KEY CLUSTERED 
(
	[idGrupoCarenciaProcedimento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[GrupoCarenciaProcedimento]  WITH CHECK ADD  CONSTRAINT [FK_GrupoCarenciaProcedimento_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[GrupoCarenciaProcedimento] CHECK CONSTRAINT [FK_GrupoCarenciaProcedimento_FUNCIONARIO]
ALTER TABLE [dbo].[GrupoCarenciaProcedimento]  WITH CHECK ADD  CONSTRAINT [FK_GrupoCarenciaProcedimento_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[GrupoCarenciaProcedimento] CHECK CONSTRAINT [FK_GrupoCarenciaProcedimento_FUNCIONARIO1]
ALTER TABLE [dbo].[GrupoCarenciaProcedimento]  WITH CHECK ADD  CONSTRAINT [FK_GrupoCarenciaProcedimento_GrupoCarencia] FOREIGN KEY([idGrupoCarencia])
REFERENCES [dbo].[GrupoCarencia] ([idGrupoCarencia])
ALTER TABLE [dbo].[GrupoCarenciaProcedimento] CHECK CONSTRAINT [FK_GrupoCarenciaProcedimento_GrupoCarencia]
ALTER TABLE [dbo].[GrupoCarenciaProcedimento]  WITH CHECK ADD  CONSTRAINT [FK_GrupoCarenciaProcedimento_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[GrupoCarenciaProcedimento] CHECK CONSTRAINT [FK_GrupoCarenciaProcedimento_SERVICO]
