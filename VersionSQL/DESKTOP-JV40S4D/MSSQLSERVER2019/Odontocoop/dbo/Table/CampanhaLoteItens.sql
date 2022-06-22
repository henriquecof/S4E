/****** Object:  Table [dbo].[CampanhaLoteItens]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CampanhaLoteItens](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[cd_campanha] [smallint] NOT NULL,
	[cd_campanha_lote] [int] NULL,
	[chaId] [int] NULL,
	[ID_ERP_CRM] [bigint] NULL,
	[Nome_Prospect] [varchar](1000) NOT NULL,
	[DtNascimento] [datetime] NULL,
	[CPF_CNPJ] [varchar](14) NULL,
	[RG_CGF] [varchar](200) NULL,
	[email] [varchar](1000) NULL,
	[sexo] [smallint] NULL,
	[Logradouro] [varchar](1000) NULL,
	[Complemento] [varchar](500) NULL,
	[Bairro] [varchar](1000) NULL,
	[cep] [varchar](8) NULL,
	[cidade] [varchar](1000) NULL,
	[estado] [varchar](2) NULL,
	[Data_ERP_CRM] [datetime] NULL,
	[Telefone_Contato_1] [varchar](100) NULL,
	[Telefone_Contato_2] [varchar](100) NULL,
	[Telefone_Contato_3] [varchar](100) NULL,
	[Contato_1] [varchar](1000) NULL,
	[Numero_Titulo] [varchar](1000) NULL,
	[Tipo_Titulo] [varchar](1000) NULL,
	[Data_Titulo] [datetime] NULL,
	[Valor_Titulo] [money] NULL,
	[Produto] [varchar](1000) NULL,
	[Filial] [varchar](1000) NULL,
	[Dia_Vencimento] [smallint] NULL,
	[Informacao_Adicional_1] [varchar](1000) NULL,
	[Informacao_Adicional_2] [varchar](1000) NULL,
	[Informacao_Adicional_3] [varchar](1000) NULL,
	[Auxiliar_1] [varchar](1000) NULL,
	[Auxiliar_2] [varchar](1000) NULL,
	[Auxiliar_3] [varchar](1000) NULL,
	[Agrupador] [int] NULL,
	[Dt_Atendimento] [datetime] NULL,
	[Nm_Funcionario] [varchar](100) NULL,
	[Nm_Clinica] [varchar](100) NULL,
	[Cd_empresa] [bigint] NULL,
	[Cd_centro_custo] [smallint] NULL,
	[cd_tipo_campanha] [smallint] NULL,
	[DS_tipo_campanha] [varchar](50) NULL,
	[cd_parcela] [int] NULL,
	[cd_sequencial_agenda] [int] NULL,
	[dt_ordenacao] [datetime] NULL,
	[cd_sequencial_dep] [int] NULL,
 CONSTRAINT [PK_CampanhaLoteItens] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_CampanhaLoteItens] ON [dbo].[CampanhaLoteItens]
(
	[cd_campanha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaLoteItens_1] ON [dbo].[CampanhaLoteItens]
(
	[cd_campanha_lote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaLoteItens_2] ON [dbo].[CampanhaLoteItens]
(
	[chaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaLoteItens_3] ON [dbo].[CampanhaLoteItens]
(
	[ID_ERP_CRM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaLoteItens_4] ON [dbo].[CampanhaLoteItens]
(
	[id] ASC,
	[cd_campanha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaLoteItens_5] ON [dbo].[CampanhaLoteItens]
(
	[cd_campanha] ASC,
	[cd_campanha_lote] ASC,
	[ID_ERP_CRM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaLoteItens_6] ON [dbo].[CampanhaLoteItens]
(
	[id] ASC,
	[ID_ERP_CRM] ASC,
	[cd_campanha] ASC,
	[cd_campanha_lote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaLoteItens_7] ON [dbo].[CampanhaLoteItens]
(
	[cd_campanha] ASC,
	[cd_campanha_lote] ASC,
	[id] ASC,
	[ID_ERP_CRM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaLoteItens_8] ON [dbo].[CampanhaLoteItens]
(
	[cd_campanha] ASC,
	[cd_campanha_lote] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_dt_ordenacao] ON [dbo].[CampanhaLoteItens]
(
	[dt_ordenacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [missing_index_505579] ON [dbo].[CampanhaLoteItens]
(
	[chaId] ASC,
	[ID_ERP_CRM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [teste] ON [dbo].[CampanhaLoteItens]
(
	[ID_ERP_CRM] ASC,
	[cd_campanha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CampanhaLoteItens]  WITH NOCHECK ADD  CONSTRAINT [FK_CampanhaLoteItens_Campanha] FOREIGN KEY([cd_campanha])
REFERENCES [dbo].[Campanha] ([cd_campanha])
ALTER TABLE [dbo].[CampanhaLoteItens] CHECK CONSTRAINT [FK_CampanhaLoteItens_Campanha]
ALTER TABLE [dbo].[CampanhaLoteItens]  WITH NOCHECK ADD  CONSTRAINT [FK_CampanhaLoteItens_CampanhaLote] FOREIGN KEY([cd_campanha_lote])
REFERENCES [dbo].[CampanhaLote] ([cd_campanha_lote])
ALTER TABLE [dbo].[CampanhaLoteItens] CHECK CONSTRAINT [FK_CampanhaLoteItens_CampanhaLote]
ALTER TABLE [dbo].[CampanhaLoteItens]  WITH NOCHECK ADD  CONSTRAINT [FK_CampanhaLoteItens_Centro_Custo] FOREIGN KEY([Cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[CampanhaLoteItens] CHECK CONSTRAINT [FK_CampanhaLoteItens_Centro_Custo]
ALTER TABLE [dbo].[CampanhaLoteItens]  WITH NOCHECK ADD  CONSTRAINT [FK_CampanhaLoteItens_EMPRESA] FOREIGN KEY([Cd_empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ON UPDATE CASCADE
ALTER TABLE [dbo].[CampanhaLoteItens] CHECK CONSTRAINT [FK_CampanhaLoteItens_EMPRESA]
