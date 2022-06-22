/****** Object:  Table [dbo].[ddd]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ddd](
	[codigo_nacional] [tinyint] NOT NULL,
	[qt_digcelular] [smallint] NULL,
	[qt_digfixo] [smallint] NOT NULL,
	[prefixo_celular] [varchar](50) NOT NULL,
	[prefixo_fixo] [varchar](50) NOT NULL
) ON [PRIMARY]
