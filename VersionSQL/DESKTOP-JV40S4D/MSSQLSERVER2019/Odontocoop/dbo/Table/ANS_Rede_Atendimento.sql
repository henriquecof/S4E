/****** Object:  Table [dbo].[ANS_Rede_Atendimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ANS_Rede_Atendimento](
	[cd_loteRPS_Rede] [int] NOT NULL,
	[cd_filial] [int] NOT NULL,
	[tp_estabecimento] [varchar](4) NULL,
	[tp_contratacao] [varchar](1) NULL,
	[dt_contrato] [datetime] NULL,
	[dt_iniVinculo] [datetime] NULL,
	[cd_classificacao_est] [tinyint] NULL,
	[nr_ANSinter] [varchar](6) NULL,
	[cd_dispon_serv] [varchar](1) NULL,
	[cd_ind_urgencia] [varchar](1) NULL,
	[dt_exclusao] [datetime] NULL,
 CONSTRAINT [PK_ANS_Rede_Atendimento] PRIMARY KEY CLUSTERED 
(
	[cd_loteRPS_Rede] ASC,
	[cd_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
