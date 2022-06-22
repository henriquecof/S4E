/****** Object:  Table [dbo].[Pagamento_Corretor_Aliquotas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Pagamento_Corretor_Aliquotas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_lote_comissao] [int] NOT NULL,
	[cd_aliquota] [smallint] NOT NULL,
	[vl_referencia] [money] NOT NULL,
	[perc_aliquota] [float] NOT NULL,
	[valor_aliquota] [money] NOT NULL,
	[dt_gerado] [datetime] NOT NULL,
	[dt_exclusao] [datetime] NULL,
	[id_retido] [tinyint] NOT NULL,
 CONSTRAINT [PK_Pagamento_Corretor_Aliquotas] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Pagamento_Corretor_Aliquotas]  WITH CHECK ADD  CONSTRAINT [FK_Pagamento_Corretor_Aliquotas_Aliquota] FOREIGN KEY([cd_aliquota])
REFERENCES [dbo].[Aliquota] ([cd_aliquota])
ALTER TABLE [dbo].[Pagamento_Corretor_Aliquotas] CHECK CONSTRAINT [FK_Pagamento_Corretor_Aliquotas_Aliquota]
ALTER TABLE [dbo].[Pagamento_Corretor_Aliquotas]  WITH CHECK ADD  CONSTRAINT [FK_Pagamento_Corretor_Aliquotas_lote_comissao] FOREIGN KEY([cd_lote_comissao])
REFERENCES [dbo].[lote_comissao] ([cd_sequencial])
ALTER TABLE [dbo].[Pagamento_Corretor_Aliquotas] CHECK CONSTRAINT [FK_Pagamento_Corretor_Aliquotas_lote_comissao]
