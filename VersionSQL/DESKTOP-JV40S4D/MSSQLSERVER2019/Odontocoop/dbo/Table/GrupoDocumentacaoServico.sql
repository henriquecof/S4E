/****** Object:  Table [dbo].[GrupoDocumentacaoServico]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoDocumentacaoServico](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idGrupo] [int] NOT NULL,
	[cdServico] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[GrupoDocumentacaoServico]  WITH CHECK ADD  CONSTRAINT [FK_GrupoDocumentacaoServico_GrupoDocumentacao] FOREIGN KEY([idGrupo])
REFERENCES [dbo].[GrupoDocumentacao] ([idGrupo])
ALTER TABLE [dbo].[GrupoDocumentacaoServico] CHECK CONSTRAINT [FK_GrupoDocumentacaoServico_GrupoDocumentacao]
ALTER TABLE [dbo].[GrupoDocumentacaoServico]  WITH CHECK ADD  CONSTRAINT [FK_GrupoDocumentacaoServico_Servico] FOREIGN KEY([cdServico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[GrupoDocumentacaoServico] CHECK CONSTRAINT [FK_GrupoDocumentacaoServico_Servico]
