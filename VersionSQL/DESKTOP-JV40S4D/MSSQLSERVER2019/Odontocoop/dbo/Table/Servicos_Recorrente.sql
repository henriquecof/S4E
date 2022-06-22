/****** Object:  Table [dbo].[Servicos_Recorrente]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Servicos_Recorrente](
	[cd_servico] [int] NOT NULL,
	[cd_funcionario] [int] NULL,
	[cd_centro_custo] [smallint] NULL,
	[cd_filial] [int] NULL,
	[cd_servRecorrentes] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Servicos_Recorrente] PRIMARY KEY CLUSTERED 
(
	[cd_servRecorrentes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Servicos_Recorrente]  WITH NOCHECK ADD  CONSTRAINT [FK_Servicos_Recorrente_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[Servicos_Recorrente] CHECK CONSTRAINT [FK_Servicos_Recorrente_Centro_Custo]
ALTER TABLE [dbo].[Servicos_Recorrente]  WITH NOCHECK ADD  CONSTRAINT [FK_Servicos_Recorrente_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[Servicos_Recorrente] CHECK CONSTRAINT [FK_Servicos_Recorrente_FILIAL]
ALTER TABLE [dbo].[Servicos_Recorrente]  WITH NOCHECK ADD  CONSTRAINT [FK_Servicos_Recorrente_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[Servicos_Recorrente] CHECK CONSTRAINT [FK_Servicos_Recorrente_SERVICO]
