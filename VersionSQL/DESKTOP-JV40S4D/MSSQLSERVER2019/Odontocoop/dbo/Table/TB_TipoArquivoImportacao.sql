/****** Object:  Table [dbo].[TB_TipoArquivoImportacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_TipoArquivoImportacao](
	[SQTipoArquivoImportacao] [smallint] NOT NULL,
	[Descricao] [varchar](50) NOT NULL,
	[Layout] [varchar](500) NULL,
	[fl_ativo] [smallint] NULL,
 CONSTRAINT [PK_TB_TipoArquivoImportacao] PRIMARY KEY CLUSTERED 
(
	[SQTipoArquivoImportacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
