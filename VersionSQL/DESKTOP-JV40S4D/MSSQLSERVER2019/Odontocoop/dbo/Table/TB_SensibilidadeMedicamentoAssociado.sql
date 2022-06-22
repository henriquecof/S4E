/****** Object:  Table [dbo].[TB_SensibilidadeMedicamentoAssociado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_SensibilidadeMedicamentoAssociado](
	[SequencialSensibilidadeMedicamentoAssociado] [int] IDENTITY(1,1) NOT NULL,
	[cd_associado] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_sequencial_medicamento] [int] NOT NULL,
 CONSTRAINT [PK_TB_SensibilidadeMedicamentoAssociado] PRIMARY KEY CLUSTERED 
(
	[SequencialSensibilidadeMedicamentoAssociado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_TB_SensibilidadeMedicamentoAssociado] ON [dbo].[TB_SensibilidadeMedicamentoAssociado]
(
	[cd_associado] ASC,
	[cd_sequencial_dep] ASC,
	[cd_sequencial_medicamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
