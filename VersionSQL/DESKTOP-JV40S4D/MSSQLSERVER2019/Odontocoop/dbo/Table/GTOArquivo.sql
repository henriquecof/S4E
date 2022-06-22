/****** Object:  Table [dbo].[GTOArquivo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GTOArquivo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[arquivoNome] [varchar](100) NULL,
	[arquivoExtensao] [varchar](10) NULL,
	[dados] [varbinary](max) NULL,
	[dataCadastro] [datetime] NULL,
	[idFuncionarioCadastro] [int] NULL,
	[idGTO] [int] NULL,
 CONSTRAINT [PK_GTOArquivo_3] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[GTOArquivo]  WITH CHECK ADD  CONSTRAINT [FK_GTOArquivo_FUNCIONARIO1] FOREIGN KEY([idFuncionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[GTOArquivo] CHECK CONSTRAINT [FK_GTOArquivo_FUNCIONARIO1]
ALTER TABLE [dbo].[GTOArquivo]  WITH CHECK ADD  CONSTRAINT [FK_GTOArquivo_GTOLote] FOREIGN KEY([idGTO])
REFERENCES [dbo].[GTOLote] ([gloId])
ALTER TABLE [dbo].[GTOArquivo] CHECK CONSTRAINT [FK_GTOArquivo_GTOLote]
