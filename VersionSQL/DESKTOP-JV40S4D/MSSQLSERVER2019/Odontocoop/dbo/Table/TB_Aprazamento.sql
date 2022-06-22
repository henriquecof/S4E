/****** Object:  Table [dbo].[TB_Aprazamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Aprazamento](
	[Sequencial_Aprazamento] [int] IDENTITY(1,1) NOT NULL,
	[Data_Documento] [smalldatetime] NOT NULL,
	[Historico] [varchar](500) NOT NULL,
	[Data_HoraExclusao] [smalldatetime] NULL,
	[Tempo_Lancamento] [smallint] NOT NULL,
	[Mes_Inicio_Lancamento] [smallint] NULL,
	[CD_Fornecedor] [int] NULL,
	[CD_Funcionario] [int] NULL,
	[CD_Associado] [int] NULL,
	[CD_Sequencial] [int] NULL,
	[CD_AssociadoEmpresa] [int] NULL,
	[Nome_Outros] [varchar](50) NULL,
	[Numero_Prestacao] [smallint] NULL,
	[Numero_Atual_Prestacao] [smallint] NULL,
	[Sequencial_Conta] [int] NOT NULL,
	[Tipo_Lancamento] [smallint] NOT NULL,
	[Gerar_Lancamento] [smallint] NULL,
	[CD_Dentista] [int] NULL,
	[Valor_Lancamento] [decimal](18, 2) NOT NULL,
	[Sequencial_Movimentacao] [int] NOT NULL,
 CONSTRAINT [PK_TB_Aprazamento] PRIMARY KEY CLUSTERED 
(
	[Sequencial_Aprazamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_Aprazamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Aprazamento_TB_Conta] FOREIGN KEY([Sequencial_Conta])
REFERENCES [dbo].[TB_Conta] ([Sequencial_Conta])
ALTER TABLE [dbo].[TB_Aprazamento] CHECK CONSTRAINT [FK_TB_Aprazamento_TB_Conta]
ALTER TABLE [dbo].[TB_Aprazamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Aprazamento_TB_MovimentacaoFinanceira] FOREIGN KEY([Sequencial_Movimentacao])
REFERENCES [dbo].[TB_MovimentacaoFinanceira] ([Sequencial_Movimentacao])
ALTER TABLE [dbo].[TB_Aprazamento] CHECK CONSTRAINT [FK_TB_Aprazamento_TB_MovimentacaoFinanceira]
