/****** Object:  Table [dbo].[GTO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GTO](
	[Nr_guia] [int] NOT NULL,
	[cd_funcionario] [int] NULL,
	[cd_sequencial_consulta] [int] NOT NULL,
	[dt_impressao] [datetime] NOT NULL
) ON [PRIMARY]
