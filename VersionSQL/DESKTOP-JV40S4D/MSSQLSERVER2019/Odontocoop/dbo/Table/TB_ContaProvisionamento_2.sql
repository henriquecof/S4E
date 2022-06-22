/****** Object:  Table [dbo].[TB_ContaProvisionamento_2]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ContaProvisionamento_2](
	[Sequencial_ContaProvisionamento] [int] NOT NULL,
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
	[Competencia] [date] NULL
) ON [PRIMARY]
