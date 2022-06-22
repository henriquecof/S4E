/****** Object:  Table [dbo].[Lote_Processos_bancos_resumo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_Processos_bancos_resumo](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_lote] [int] NOT NULL,
	[cd_associado] [int] NOT NULL,
	[acao] [varchar](1) NOT NULL,
	[nm_situacao] [varchar](100) NULL,
 CONSTRAINT [PK_Lote_Processos_bancos_resumo] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
