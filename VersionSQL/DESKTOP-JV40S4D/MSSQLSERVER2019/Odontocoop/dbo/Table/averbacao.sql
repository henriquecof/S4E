/****** Object:  Table [dbo].[averbacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[averbacao](
	[cd_sequencial_averbacao] [int] IDENTITY(1,1) NOT NULL,
	[cd_Associado] [int] NOT NULL,
	[cd_operacao] [char](1) NOT NULL,
	[cd_sequencial] [int] NULL,
	[cd_retorno] [smallint] NULL,
	[vl_parcela] [money] NULL,
	[mensagem] [varchar](100) NULL,
	[nm_sacado] [varchar](100) NULL,
	[valor] [money] NULL,
	[nr_orcamento] [int] NULL,
	[qtd_parcelas] [int] NULL,
	[chaId] [int] NULL,
 CONSTRAINT [PK_averbação] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_averbacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[averbacao]  WITH CHECK ADD FOREIGN KEY([chaId])
REFERENCES [dbo].[CRMChamado] ([chaId])
ALTER TABLE [dbo].[averbacao]  WITH NOCHECK ADD  CONSTRAINT [FK_averbação_ASSOCIADOS] FOREIGN KEY([cd_Associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[averbacao] CHECK CONSTRAINT [FK_averbação_ASSOCIADOS]
ALTER TABLE [dbo].[averbacao]  WITH NOCHECK ADD  CONSTRAINT [FK_averbação_Averbacao_lote] FOREIGN KEY([cd_sequencial])
REFERENCES [dbo].[Averbacao_lote] ([cd_sequencial])
ALTER TABLE [dbo].[averbacao] CHECK CONSTRAINT [FK_averbação_Averbacao_lote]
ALTER TABLE [dbo].[averbacao]  WITH NOCHECK ADD  CONSTRAINT [FK_averbação_DEB_AUTOMATICO_CR] FOREIGN KEY([cd_retorno])
REFERENCES [dbo].[DEB_AUTOMATICO_CR] ([cd_ocorrencia])
ALTER TABLE [dbo].[averbacao] CHECK CONSTRAINT [FK_averbação_DEB_AUTOMATICO_CR]
ALTER TABLE [dbo].[averbacao]  WITH NOCHECK ADD  CONSTRAINT [FK_averbação_DEB_AUTOMATICO_CR1] FOREIGN KEY([cd_retorno])
REFERENCES [dbo].[DEB_AUTOMATICO_CR] ([cd_ocorrencia])
ALTER TABLE [dbo].[averbacao] CHECK CONSTRAINT [FK_averbação_DEB_AUTOMATICO_CR1]
