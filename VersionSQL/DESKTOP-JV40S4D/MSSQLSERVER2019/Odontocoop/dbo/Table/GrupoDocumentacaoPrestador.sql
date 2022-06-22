/****** Object:  Table [dbo].[GrupoDocumentacaoPrestador]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoDocumentacaoPrestador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idGrupo] [int] NOT NULL,
	[idPrestador] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[GrupoDocumentacaoPrestador]  WITH CHECK ADD  CONSTRAINT [FK_GrupoDocumentacaoPrestador_Funcionario] FOREIGN KEY([idPrestador])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[GrupoDocumentacaoPrestador] CHECK CONSTRAINT [FK_GrupoDocumentacaoPrestador_Funcionario]
ALTER TABLE [dbo].[GrupoDocumentacaoPrestador]  WITH CHECK ADD  CONSTRAINT [FK_GrupoDocumentacaoPrestador_GrupoDocumentacao] FOREIGN KEY([idGrupo])
REFERENCES [dbo].[GrupoDocumentacao] ([idGrupo])
ALTER TABLE [dbo].[GrupoDocumentacaoPrestador] CHECK CONSTRAINT [FK_GrupoDocumentacaoPrestador_GrupoDocumentacao]
