/****** Object:  Table [dbo].[beneficiarios_fora_carencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[beneficiarios_fora_carencia](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ano_mes] [varchar](10) NULL,
	[quantidade] [int] NULL,
	[ano] [smallint] NULL,
	[mes] [smallint] NULL
) ON [PRIMARY]
