/****** Object:  Table [dbo].[ANS_RPS_Itens]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ANS_RPS_Itens](
	[cd_sequencial_itens] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial] [int] NOT NULL,
	[cd_filial] [int] NULL,
	[acao] [varchar](1) NOT NULL,
	[dt_excluido] [datetime] NULL,
	[cd_usuario_exc] [int] NULL,
	[Prestador] [varchar](14) NULL,
	[NR_CGC] [varchar](1) NULL,
	[Cnes] [varchar](10) NULL,
	[Cidid] [int] NULL,
	[tp_contratacao] [varchar](1) NULL,
	[nr_ANSinter] [int] NULL,
	[cd_dispon_serv] [varchar](1) NULL,
	[data_contrato] [datetime] NULL,
	[Data_Inicio_Vinculo] [datetime] NULL,
	[cd_ind_urgencia] [varchar](1) NULL,
	[ufid] [smallint] NULL,
 CONSTRAINT [PK_ANS_RPS_Itens] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_itens] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
