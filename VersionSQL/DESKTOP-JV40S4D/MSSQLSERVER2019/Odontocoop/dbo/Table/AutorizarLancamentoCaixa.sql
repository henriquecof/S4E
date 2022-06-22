/****** Object:  Table [dbo].[AutorizarLancamentoCaixa]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AutorizarLancamentoCaixa](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[funcionarioAutorizacao] [int] NULL,
	[dataAutorizacao] [datetime] NULL,
	[lancamento] [int] NULL,
	[descricao] [varchar](500) NULL,
 CONSTRAINT [PK_AutorizarLancamentoCaixa] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AutorizarLancamentoCaixa]  WITH CHECK ADD  CONSTRAINT [FK_AutorizarLancamentoCaixa_FUNCIONARIO] FOREIGN KEY([funcionarioAutorizacao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[AutorizarLancamentoCaixa] CHECK CONSTRAINT [FK_AutorizarLancamentoCaixa_FUNCIONARIO]
ALTER TABLE [dbo].[AutorizarLancamentoCaixa]  WITH CHECK ADD  CONSTRAINT [FK_AutorizarLancamentoCaixa_TB_Lancamento] FOREIGN KEY([lancamento])
REFERENCES [dbo].[TB_Lancamento] ([Sequencial_Lancamento])
ALTER TABLE [dbo].[AutorizarLancamentoCaixa] CHECK CONSTRAINT [FK_AutorizarLancamentoCaixa_TB_Lancamento]
