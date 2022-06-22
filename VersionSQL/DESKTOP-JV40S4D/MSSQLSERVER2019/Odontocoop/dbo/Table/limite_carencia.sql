/****** Object:  Table [dbo].[limite_carencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[limite_carencia](
	[cd_Sequencial_dep] [int] NULL,
	[cd_Associado] [int] NULL,
	[dt_inicio_carencia] [date] NULL,
	[fl_temcarencia] [int] NULL,
	[dias] [int] NULL,
	[dt_fim_carencia] [date] NULL
) ON [PRIMARY]
