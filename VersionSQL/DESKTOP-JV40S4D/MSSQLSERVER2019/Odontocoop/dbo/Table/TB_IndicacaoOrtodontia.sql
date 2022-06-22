/****** Object:  Table [dbo].[TB_IndicacaoOrtodontia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_IndicacaoOrtodontia](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[cd_associado] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[Necessidade] [bit] NOT NULL,
	[cd_filial] [int] NOT NULL,
	[fl_VisualizadoRecepcao] [bit] NULL,
	[DtCadastro] [datetime] NOT NULL,
 CONSTRAINT [PK_TB_IndicacaoOrtodontia_1] PRIMARY KEY CLUSTERED 
(
	[cd_associado] ASC,
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_TB_IndicacaoOrtodontia_1] ON [dbo].[TB_IndicacaoOrtodontia]
(
	[cd_associado] ASC,
	[DtCadastro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TB_IndicacaoOrtodontia]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_IndicacaoOrtodontia_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[TB_IndicacaoOrtodontia] CHECK CONSTRAINT [FK_TB_IndicacaoOrtodontia_FILIAL]
