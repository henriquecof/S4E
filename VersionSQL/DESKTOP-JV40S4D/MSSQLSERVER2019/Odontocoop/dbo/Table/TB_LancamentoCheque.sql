/****** Object:  Table [dbo].[TB_LancamentoCheque]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_LancamentoCheque](
	[Sequencial_Lancamento_Cheque] [int] IDENTITY(1,1) NOT NULL,
	[Sequencial_Agencia] [int] NULL,
	[Numero_Cheque] [varchar](20) NULL,
	[Sequencial_FormaLancamento] [int] NOT NULL,
	[Situacao_Cheque] [smallint] NOT NULL,
	[nome_usuario] [varchar](20) NULL,
	[codigo_banco] [varchar](20) NULL,
	[codigo_agencia] [varchar](20) NULL,
	[Imprime_Cheque] [smallint] NULL,
	[Numero_Conta] [varchar](20) NULL,
	[valor] [money] NULL,
	[valorExtenso] [varchar](150) NULL,
	[nominal] [varchar](50) NULL,
	[localidade] [varchar](50) NULL,
	[dia] [varchar](2) NULL,
	[mesExtenso] [varchar](50) NULL,
	[ano] [int] NULL,
	[dataCadastro] [datetime] NULL,
	[chave] [varchar](50) NULL,
 CONSTRAINT [PK_TB_LancamentoCheque] PRIMARY KEY CLUSTERED 
(
	[Sequencial_Lancamento_Cheque] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_LancamentoCheque]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_LancamentoCheque_TB_Agencia] FOREIGN KEY([Sequencial_Agencia])
REFERENCES [dbo].[TB_Agencia] ([Sequencial_Agencia])
ALTER TABLE [dbo].[TB_LancamentoCheque] CHECK CONSTRAINT [FK_TB_LancamentoCheque_TB_Agencia]
ALTER TABLE [dbo].[TB_LancamentoCheque]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_LancamentoCheque_TB_FormaLancamento] FOREIGN KEY([Sequencial_FormaLancamento])
REFERENCES [dbo].[TB_FormaLancamento] ([Sequencial_FormaLancamento])
ALTER TABLE [dbo].[TB_LancamentoCheque] CHECK CONSTRAINT [FK_TB_LancamentoCheque_TB_FormaLancamento]
