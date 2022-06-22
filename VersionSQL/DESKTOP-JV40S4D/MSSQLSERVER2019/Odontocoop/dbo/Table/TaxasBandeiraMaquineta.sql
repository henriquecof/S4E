/****** Object:  Table [dbo].[TaxasBandeiraMaquineta]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TaxasBandeiraMaquineta](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idOrigemCartao] [int] NOT NULL,
	[idCartao] [int] NOT NULL,
	[valorTaxaCredito] [money] NOT NULL,
	[valorTaxaDebito] [money] NOT NULL,
	[parcelaInicial] [smallint] NOT NULL,
	[parcelaFinal] [smallint] NOT NULL,
	[usuarioCadastro] [int] NULL,
	[dataCadastro] [datetime] NULL,
 CONSTRAINT [PK_TaxasBandeiraMaquineta] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TaxasBandeiraMaquineta]  WITH CHECK ADD  CONSTRAINT [FK_TaxasBandeiraMaquineta_FUNCIONARIO] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[TaxasBandeiraMaquineta] CHECK CONSTRAINT [FK_TaxasBandeiraMaquineta_FUNCIONARIO]
ALTER TABLE [dbo].[TaxasBandeiraMaquineta]  WITH CHECK ADD  CONSTRAINT [FK_TaxasBandeiraMaquineta_TB_Cartao_Car] FOREIGN KEY([idCartao])
REFERENCES [dbo].[TB_Cartao_Car] ([SequencialCartao_Car])
ALTER TABLE [dbo].[TaxasBandeiraMaquineta] CHECK CONSTRAINT [FK_TaxasBandeiraMaquineta_TB_Cartao_Car]
ALTER TABLE [dbo].[TaxasBandeiraMaquineta]  WITH CHECK ADD  CONSTRAINT [FK_TaxasBandeiraMaquineta_TB_OrigemCartao] FOREIGN KEY([idOrigemCartao])
REFERENCES [dbo].[TB_OrigemCartao] ([Codigo_OrigemCartao])
ALTER TABLE [dbo].[TaxasBandeiraMaquineta] CHECK CONSTRAINT [FK_TaxasBandeiraMaquineta_TB_OrigemCartao]
