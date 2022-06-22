/****** Object:  Table [dbo].[DownloadArquivo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DownloadArquivo](
	[darId] [int] IDENTITY(1,1) NOT NULL,
	[darArquivo] [varchar](50) NULL,
	[darDescricao] [varchar](100) NULL,
	[darDtCadastro] [datetime] NULL,
	[darDtExclusao] [datetime] NULL,
	[cd_funcionarioCadastro] [int] NULL,
	[ufIds] [varchar](100) NULL,
	[municipioIds] [varchar](8000) NULL,
	[filialIds] [varchar](8000) NULL,
	[cd_centro_custo] [smallint] NULL,
 CONSTRAINT [PK_DownloadArquivo] PRIMARY KEY CLUSTERED 
(
	[darId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DownloadArquivo]  WITH CHECK ADD  CONSTRAINT [FK_Centro_Custo_cd_centro_custo_DownloadArquivo_cd_centro_custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[DownloadArquivo] CHECK CONSTRAINT [FK_Centro_Custo_cd_centro_custo_DownloadArquivo_cd_centro_custo]
