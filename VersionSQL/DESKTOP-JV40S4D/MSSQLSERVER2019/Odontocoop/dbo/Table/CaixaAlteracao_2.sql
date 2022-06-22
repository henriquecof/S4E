/****** Object:  Table [dbo].[CaixaAlteracao_2]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CaixaAlteracao_2](
	[id] [int] NOT NULL,
	[usuario] [int] NULL,
	[data] [datetime] NULL,
	[sequencial_historico] [int] NULL,
	[historico] [varchar](500) NULL
) ON [PRIMARY]
