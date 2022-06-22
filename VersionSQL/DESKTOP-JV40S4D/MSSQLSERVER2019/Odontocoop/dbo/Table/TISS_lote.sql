/****** Object:  Table [dbo].[TISS_lote]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TISS_lote](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[variacao] [int] NOT NULL,
	[referencia] [varchar](6) NOT NULL,
	[dt_abertura] [datetime] NULL,
	[dt_gerado] [datetime] NULL,
	[dt_fechado] [datetime] NULL,
	[dt_retorno] [datetime] NULL,
	[nm_arquivo] [varchar](50) NULL,
	[fl_processado] [smallint] NULL,
	[er_arquivo] [float] NULL,
	[variacao_final] [int] NULL,
	[erro] [varchar](max) NULL,
	[tipoRegistro] [tinyint] NULL,
	[chaveExportacao] [varchar](50) NULL,
	[dt_geradoDados] [datetime] NULL,
	[idConvenio] [int] NULL,
 CONSTRAINT [PK_TISS_lote] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
