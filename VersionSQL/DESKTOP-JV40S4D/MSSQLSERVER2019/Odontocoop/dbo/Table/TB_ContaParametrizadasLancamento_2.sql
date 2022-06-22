/****** Object:  Table [dbo].[TB_ContaParametrizadasLancamento_2]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ContaParametrizadasLancamento_2](
	[cd_sequencial_para] [int] NOT NULL,
	[sequencial_lancamento] [int] NOT NULL,
	[dt_competencia] [datetime] NOT NULL,
	[dt_recebido] [datetime] NULL
) ON [PRIMARY]
