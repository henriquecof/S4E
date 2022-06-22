/****** Object:  Table [dbo].[Pagamento_Dentista_Aliquotas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Pagamento_Dentista_Aliquotas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_pgto_dentista_lanc] [int] NOT NULL,
	[cd_aliquota] [smallint] NOT NULL,
	[vl_referencia] [money] NOT NULL,
	[perc_aliquota] [float] NOT NULL,
	[valor_aliquota] [money] NOT NULL,
	[dt_gerado] [datetime] NOT NULL,
	[dt_exclusao] [datetime] NULL,
	[id_retido] [tinyint] NOT NULL,
 CONSTRAINT [PK_Pagamento_Dentista_Aliquotas] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Pagamento_Dentista_Aliquotas] ON [dbo].[Pagamento_Dentista_Aliquotas]
(
	[cd_pgto_dentista_lanc] ASC,
	[cd_aliquota] ASC,
	[dt_exclusao] ASC,
	[id_retido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Pagamento_Dentista_Aliquotas]  WITH NOCHECK ADD  CONSTRAINT [FK_Pagamento_Dentista_Aliquotas_Aliquota] FOREIGN KEY([cd_aliquota])
REFERENCES [dbo].[Aliquota] ([cd_aliquota])
ALTER TABLE [dbo].[Pagamento_Dentista_Aliquotas] CHECK CONSTRAINT [FK_Pagamento_Dentista_Aliquotas_Aliquota]
ALTER TABLE [dbo].[Pagamento_Dentista_Aliquotas]  WITH NOCHECK ADD  CONSTRAINT [FK_Pagamento_Dentista_Aliquotas_Pagamento_Dentista_Lancamento] FOREIGN KEY([cd_pgto_dentista_lanc])
REFERENCES [dbo].[Pagamento_Dentista_Lancamento] ([cd_pgto_dentista_lanc])
ALTER TABLE [dbo].[Pagamento_Dentista_Aliquotas] CHECK CONSTRAINT [FK_Pagamento_Dentista_Aliquotas_Pagamento_Dentista_Lancamento]
