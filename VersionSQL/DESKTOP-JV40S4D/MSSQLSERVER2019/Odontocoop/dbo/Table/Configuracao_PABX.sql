/****** Object:  Table [dbo].[Configuracao_PABX]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Configuracao_PABX](
	[cd_Config] [tinyint] IDENTITY(1,1) NOT NULL,
	[nm_host_cti] [varchar](100) NOT NULL,
	[nm_host_pabx] [varchar](100) NOT NULL,
	[nm_login] [varchar](20) NOT NULL,
	[senha] [varchar](10) NOT NULL,
	[contexto_fila] [varchar](100) NOT NULL,
	[contexto_discagem] [varchar](100) NULL,
	[canal_discagem] [varchar](100) NULL,
	[caminho_audios] [varchar](100) NOT NULL,
	[fl_AnoMes_audio] [bit] NOT NULL,
	[faixa_ini] [varchar](8) NOT NULL,
	[faixa_fin] [varchar](8) NOT NULL,
	[exten_discagem] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Configuracao_PABX] PRIMARY KEY CLUSTERED 
(
	[cd_Config] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
