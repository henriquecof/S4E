/****** Object:  Table [dbo].[Lote_RPC_Empresa]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_RPC_Empresa](
	[cd_empresa] [int] NOT NULL,
	[ds_classificacao] [varchar](50) NULL,
	[cd_ans] [varchar](10) NOT NULL,
	[cd_grupo_plano] [int] NULL,
	[dt_cadastro] [datetime] NULL,
	[dt_exclusao] [datetime] NULL,
	[dt_inicial_aplicacao] [varchar](7) NULL,
	[dt_final_aplicacao] [varchar](7) NULL,
	[dt_inicial_analise] [varchar](7) NULL,
	[dt_final_analise] [varchar](7) NULL,
	[mod_contratacao] [smallint] NULL,
	[perc_reajuste] [float] NULL,
	[qt_beneficiarios] [int] NULL,
	[uf_contrato] [int] NULL,
	[disp_beneficiarios] [varchar](1) NULL,
	[cd_caracteristica_reajuste] [smallint] NULL,
	[reajuste_linear] [bit] NULL,
	[alt_franq_coparticipacao] [bit] NULL,
	[perc_reajuste_copart] [float] NULL,
	[cd_plano_operadora] [varchar](10) NULL,
	[ano_trimestre] [int] NOT NULL,
	[cd_variacao] [int] NOT NULL,
	[ds_justificativa] [varchar](1000) NULL,
	[nr_contrato_plano] [varchar](20) NULL,
 CONSTRAINT [PK_Lote_RPC_Empresa] PRIMARY KEY CLUSTERED 
(
	[cd_empresa] ASC,
	[cd_ans] ASC,
	[ano_trimestre] ASC,
	[cd_variacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
