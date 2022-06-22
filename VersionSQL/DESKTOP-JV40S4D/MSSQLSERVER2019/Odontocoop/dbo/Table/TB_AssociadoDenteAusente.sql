/****** Object:  Table [dbo].[TB_AssociadoDenteAusente]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_AssociadoDenteAusente](
	[cd_associado] [int] NULL,
	[nm_dependente] [varchar](100) NULL,
	[cd_empresa] [int] NULL,
	[nm_empresa] [varchar](100) NULL,
	[cd_ud] [varchar](5) NULL,
	[cd_sequencial] [int] NULL
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_TB_AssociadoDenteHigido_1] ON [dbo].[TB_AssociadoDenteAusente]
(
	[cd_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
