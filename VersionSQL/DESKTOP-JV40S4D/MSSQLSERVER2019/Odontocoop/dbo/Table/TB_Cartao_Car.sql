/****** Object:  Table [dbo].[TB_Cartao_Car]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Cartao_Car](
	[SequencialCartao_Car] [int] NOT NULL,
	[Descricao_Car] [varchar](50) NOT NULL,
	[CartaoValido_Car] [smallint] NOT NULL,
	[Sequencial_Movimentacao] [int] NULL,
	[Dias_Credito] [smallint] NULL,
	[Quantidade_Maxima_Parcela] [smallint] NULL,
	[Aceita_Credito] [smallint] NULL,
	[Aceita_Debito] [smallint] NULL,
	[qtdl_digitosCartao] [tinyint] NULL,
	[logo_bandeira] [varchar](100) NULL,
	[permiteParcelamentoPortalAssociado] [bit] NULL,
 CONSTRAINT [PK_TB_Cartao_Car] PRIMARY KEY CLUSTERED 
(
	[SequencialCartao_Car] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_Cartao_Car]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Cartao_Car_TB_MovimentacaoFinanceira] FOREIGN KEY([Sequencial_Movimentacao])
REFERENCES [dbo].[TB_MovimentacaoFinanceira] ([Sequencial_Movimentacao])
ALTER TABLE [dbo].[TB_Cartao_Car] CHECK CONSTRAINT [FK_TB_Cartao_Car_TB_MovimentacaoFinanceira]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sequencial' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Cartao_Car', @level2type=N'COLUMN',@level2name=N'SequencialCartao_Car'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descricao' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Cartao_Car', @level2type=N'COLUMN',@level2name=N'Descricao_Car'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cartao Valido' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Cartao_Car', @level2type=N'COLUMN',@level2name=N'CartaoValido_Car'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sequencial Movimentacao Financeira' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Cartao_Car', @level2type=N'COLUMN',@level2name=N'Sequencial_Movimentacao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dias Credito' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Cartao_Car', @level2type=N'COLUMN',@level2name=N'Dias_Credito'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Qtde Maxima Parcela' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Cartao_Car', @level2type=N'COLUMN',@level2name=N'Quantidade_Maxima_Parcela'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Aceita Credito' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Cartao_Car', @level2type=N'COLUMN',@level2name=N'Aceita_Credito'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Aceita Debito' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Cartao_Car', @level2type=N'COLUMN',@level2name=N'Aceita_Debito'
