/****** Object:  Table [dbo].[TB_MovimentacaoFinanceira]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_MovimentacaoFinanceira](
	[Sequencial_Movimentacao] [int] IDENTITY(1,1) NOT NULL,
	[Descricao_Movimentacao] [varchar](80) NOT NULL,
	[cd_centro_custo] [int] NULL,
	[Sequencial_Agencia] [int] NULL,
	[Saldo_Inicial] [decimal](19, 2) NOT NULL,
	[nome_usuario] [varchar](20) NULL,
	[Numero_Conta] [varchar](20) NULL,
	[Movimentacao_Valida] [smallint] NULL,
	[ordemsaldo] [smallint] NULL,
	[Codigo_ContaPadraoCob] [varchar](10) NULL,
	[cd_filial] [int] NULL,
	[fecha_automatico] [tinyint] NULL,
	[cd_contabilidade] [int] NULL,
	[cc_codigoLoja] [int] NULL,
 CONSTRAINT [PK_TB_MovimentacaoFinanceira] PRIMARY KEY CLUSTERED 
(
	[Sequencial_Movimentacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_MovimentacaoFinanceira]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_MovimentacaoFinanceira_TB_Agencia] FOREIGN KEY([Sequencial_Agencia])
REFERENCES [dbo].[TB_Agencia] ([Sequencial_Agencia])
ALTER TABLE [dbo].[TB_MovimentacaoFinanceira] CHECK CONSTRAINT [FK_TB_MovimentacaoFinanceira_TB_Agencia]
