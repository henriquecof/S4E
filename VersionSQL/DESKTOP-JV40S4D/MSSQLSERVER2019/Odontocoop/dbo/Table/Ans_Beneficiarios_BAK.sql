/****** Object:  Table [dbo].[Ans_Beneficiarios_BAK]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Ans_Beneficiarios_BAK](
	[cd_sequencial] [int] NOT NULL,
	[cd_sequencial_dep] [int] NULL,
	[tipo_Movimentacao] [smallint] NOT NULL,
	[dt_inclusao] [datetime] NOT NULL,
	[dt_exclusao] [datetime] NULL,
	[cd_arquivo_envio_inc] [int] NOT NULL,
	[cd_arquivo_envio_exc] [int] NULL,
	[nr_cpf] [varchar](11) NULL,
	[cd_plano_ans] [varchar](10) NULL,
	[nm_beneficiario] [varchar](100) NOT NULL,
	[dt_nascimento] [datetime] NULL,
	[cd_grau_parentesco] [smallint] NULL,
	[cd_beneficiario_titular] [int] NULL,
	[cd_empresa] [int] NULL,
	[cd_motivo_exclusao_Ans] [smallint] NULL,
	[mensagemErro] [varchar](1000) NULL,
	[cco] [varchar](12) NULL,
	[mudanca_contratual] [bit] NULL,
	[retificacao] [bit] NULL,
 CONSTRAINT [PK_Ans_Envio_BAK] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
