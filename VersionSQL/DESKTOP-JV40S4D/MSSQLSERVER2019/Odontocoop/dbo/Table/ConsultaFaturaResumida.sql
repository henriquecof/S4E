/****** Object:  Table [dbo].[ConsultaFaturaResumida]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ConsultaFaturaResumida](
	[cd_empresa] [int] NOT NULL,
	[tipo] [smallint] NOT NULL,
	[cd_associado] [int] NOT NULL,
	[valor] [money] NOT NULL,
	[cd_sequencial_dep] [int] NULL
) ON [PRIMARY]
