/****** Object:  Table [dbo].[TipoExportacaoNFe]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoExportacaoNFe](
	[tenId] [tinyint] NOT NULL,
	[tenDescricao] [varchar](50) NOT NULL,
	[fl_ativo] [bit] NULL,
 CONSTRAINT [PK_TipoExportacaoNFe] PRIMARY KEY CLUSTERED 
(
	[tenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
