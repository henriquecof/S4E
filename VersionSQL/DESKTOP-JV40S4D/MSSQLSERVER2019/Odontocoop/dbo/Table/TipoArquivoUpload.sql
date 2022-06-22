/****** Object:  Table [dbo].[TipoArquivoUpload]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoArquivoUpload](
	[id] [int] NOT NULL,
	[descricao] [varchar](50) NOT NULL,
	[ativo] [bit] NOT NULL,
	[visualizacaoGlobal] [bit] NOT NULL,
 CONSTRAINT [PK_TipoArquivoUpload] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
