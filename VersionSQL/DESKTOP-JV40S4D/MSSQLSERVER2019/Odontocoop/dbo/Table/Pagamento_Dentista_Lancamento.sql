/****** Object:  Table [dbo].[Pagamento_Dentista_Lancamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Pagamento_Dentista_Lancamento](
	[cd_pgto_dentista_lanc] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial] [int] NULL,
	[sequencial_lancamento] [int] NULL,
	[cd_filial] [int] NULL,
	[cd_funcionario] [int] NULL,
	[cd_modelo_pgto_prestador] [smallint] NOT NULL,
	[dt_gerado] [datetime] NOT NULL,
	[vl_lote] [money] NOT NULL,
	[vl_acerto] [money] NULL,
	[vl_bruto] [money] NOT NULL,
	[motivo_acerto] [varchar](1000) NULL,
	[cd_centro_custo] [smallint] NULL,
	[dt_conhecimento] [datetime] NULL,
	[valorAcrescimo] [money] NULL,
	[valorDesconto] [money] NULL,
	[valorEstorno] [money] NULL,
	[ExecutarTrigger] [bit] NULL,
	[idConvenio_ans] [int] NULL,
	[protocoloRecebimentoTissWS] [varchar](30) NULL,
	[dataProtocoloRecebimentoTissWS] [datetime] NULL,
	[erroProtocoloRecebimentoTissWS] [varchar](500) NULL,
 CONSTRAINT [PK_Pagamento_Dentista_Lancamento] PRIMARY KEY CLUSTERED 
(
	[cd_pgto_dentista_lanc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Pagamento_Dentista_Lancamento]  WITH CHECK ADD  CONSTRAINT [FK_pagamento_dentista_Lancamento_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[Pagamento_Dentista_Lancamento] CHECK CONSTRAINT [FK_pagamento_dentista_Lancamento_Centro_Custo]
ALTER TABLE [dbo].[Pagamento_Dentista_Lancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_Pagamento_Dentista_Lancamento_pagamento_dentista] FOREIGN KEY([cd_sequencial])
REFERENCES [dbo].[pagamento_dentista] ([cd_sequencial])
ALTER TABLE [dbo].[Pagamento_Dentista_Lancamento] CHECK CONSTRAINT [FK_Pagamento_Dentista_Lancamento_pagamento_dentista]
