/****** Object:  Table [dbo].[PlanoTratamentoConsultas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PlanoTratamentoConsultas](
	[ptcId] [int] NOT NULL,
	[ptrId] [int] NOT NULL,
	[cd_sequencialConsultas] [int] NOT NULL,
	[ptcDtCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[ptcDtExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
 CONSTRAINT [PK_PlanoTratamentoConsultas] PRIMARY KEY CLUSTERED 
(
	[ptcId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_PlanoTratamentoConsultas] ON [dbo].[PlanoTratamentoConsultas]
(
	[cd_sequencialConsultas] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_PlanoTratamentoConsultas_1] ON [dbo].[PlanoTratamentoConsultas]
(
	[ptrId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[PlanoTratamentoConsultas]  WITH CHECK ADD  CONSTRAINT [FK_PlanoTratamentoConsultas_Consultas] FOREIGN KEY([cd_sequencialConsultas])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[PlanoTratamentoConsultas] CHECK CONSTRAINT [FK_PlanoTratamentoConsultas_Consultas]
