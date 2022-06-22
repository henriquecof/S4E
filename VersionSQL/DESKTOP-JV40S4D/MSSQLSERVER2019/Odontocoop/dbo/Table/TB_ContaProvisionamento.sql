/****** Object:  Table [dbo].[TB_ContaProvisionamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ContaProvisionamento](
	[Sequencial_ContaProvisionamento] [int] IDENTITY(1,1) NOT NULL,
	[Valor] [float] NULL,
	[Dia] [smallint] NULL,
	[Conta_Rateio] [smallint] NULL,
	[Sequencial_Conta] [int] NULL,
	[cd_funcionario] [int] NULL,
	[Periodicidade] [smallint] NULL,
	[Lancamento_Automatico] [smallint] NULL,
	[Gerar_Dias_Lancamento] [smallint] NULL,
	[Aceita_Lancamento_Direto] [smallint] NULL,
	[Data_Fim_Lancamento_Automatico] [datetime] NULL,
	[Sequencial_Movimentacao] [int] NULL,
	[Numero_Parcelas] [smallint] NULL,
	[Observar_Chegada] [smallint] NULL,
	[Geracao_Parcelas] [smallint] NULL,
	[Percentual] [float] NULL,
	[Competencia] [date] NULL,
 CONSTRAINT [PK_TB_ContaProvisionamento] PRIMARY KEY CLUSTERED 
(
	[Sequencial_ContaProvisionamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_ContaProvisionamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_ContaProvisionamento_TB_Conta] FOREIGN KEY([Sequencial_Conta])
REFERENCES [dbo].[TB_Conta] ([Sequencial_Conta])
ALTER TABLE [dbo].[TB_ContaProvisionamento] CHECK CONSTRAINT [FK_TB_ContaProvisionamento_TB_Conta]
ALTER TABLE [dbo].[TB_ContaProvisionamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_ContaProvisionamento_TB_MovimentacaoFinanceira] FOREIGN KEY([Sequencial_Movimentacao])
REFERENCES [dbo].[TB_MovimentacaoFinanceira] ([Sequencial_Movimentacao])
ALTER TABLE [dbo].[TB_ContaProvisionamento] CHECK CONSTRAINT [FK_TB_ContaProvisionamento_TB_MovimentacaoFinanceira]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_ContaProvisionamento', @level2type=N'COLUMN',@level2name=N'Valor'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dia|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_ContaProvisionamento', @level2type=N'COLUMN',@level2name=N'Dia'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Conta Rateio|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_ContaProvisionamento', @level2type=N'COLUMN',@level2name=N'Conta_Rateio'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Conta Sequencial|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_ContaProvisionamento', @level2type=N'COLUMN',@level2name=N'Sequencial_Conta'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nome do Usuario|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_ContaProvisionamento', @level2type=N'COLUMN',@level2name=N'cd_funcionario'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Periodicidade|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_ContaProvisionamento', @level2type=N'COLUMN',@level2name=N'Periodicidade'
