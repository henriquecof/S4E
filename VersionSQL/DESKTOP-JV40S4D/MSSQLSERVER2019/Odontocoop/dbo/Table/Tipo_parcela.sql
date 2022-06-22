/****** Object:  Table [dbo].[Tipo_parcela]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tipo_parcela](
	[cd_tipo_parcela] [smallint] NOT NULL,
	[ds_tipo_parcela] [varchar](50) NOT NULL,
	[nm_cor] [nchar](7) NOT NULL,
	[fl_debito] [bit] NOT NULL,
	[fl_ativo] [bit] NOT NULL,
	[fl_parcela] [bit] NOT NULL,
	[fl_excluir_regaux] [bit] NULL,
	[fl_positivo] [bit] NOT NULL,
	[fl_ExibirInclusaoParcela] [bit] NULL,
	[ortodontia] [bit] NULL,
	[contabilizaDebito] [tinyint] NULL,
 CONSTRAINT [PK_Tipo_parcela] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
