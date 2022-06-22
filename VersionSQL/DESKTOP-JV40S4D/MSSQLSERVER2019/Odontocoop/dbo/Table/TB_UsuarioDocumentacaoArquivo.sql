/****** Object:  Table [dbo].[TB_UsuarioDocumentacaoArquivo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_UsuarioDocumentacaoArquivo](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[usuario_exclusao] [int] NULL,
	[dt_exclusao] [datetime] NULL,
	[usuario_cadastro] [int] NOT NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[NomeArquivo] [varchar](100) NOT NULL,
	[ExtensaoArquivo] [varchar](5) NOT NULL,
	[id_dominio_valor] [int] NULL,
 CONSTRAINT [PK_TB_UsuarioDocumentacaoArquivo] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_UsuarioDocumentacaoArquivo]  WITH CHECK ADD  CONSTRAINT [FK_TB_UsuarioDocumentacaoArquivo_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[TB_UsuarioDocumentacaoArquivo] CHECK CONSTRAINT [FK_TB_UsuarioDocumentacaoArquivo_DEPENDENTES]
