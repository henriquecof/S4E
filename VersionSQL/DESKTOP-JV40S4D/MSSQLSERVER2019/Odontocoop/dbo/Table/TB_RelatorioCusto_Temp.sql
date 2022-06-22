/****** Object:  Table [dbo].[TB_RelatorioCusto_Temp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_RelatorioCusto_Temp](
	[cd_filial] [int] NOT NULL,
	[Filial] [varchar](50) NOT NULL,
	[Mes] [varchar](10) NOT NULL,
	[Tipo_Classificacao] [smallint] NOT NULL,
	[Classificacao] [varchar](30) NOT NULL,
	[Valor] [float] NOT NULL
) ON [PRIMARY]
