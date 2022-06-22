/****** Object:  Table [dbo].[CaixaAlteracao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CaixaAlteracao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[usuario] [int] NULL,
	[data] [datetime] NULL,
	[sequencial_historico] [int] NULL,
	[historico] [varchar](500) NULL,
 CONSTRAINT [PK_CaixaAlteracao] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CaixaAlteracao]  WITH CHECK ADD  CONSTRAINT [FK_CaixaAlteracao_FUNCIONARIO1] FOREIGN KEY([usuario])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[CaixaAlteracao] CHECK CONSTRAINT [FK_CaixaAlteracao_FUNCIONARIO1]
ALTER TABLE [dbo].[CaixaAlteracao]  WITH CHECK ADD  CONSTRAINT [FK_CaixaAlteracao_TB_HistoricoMovimentacao] FOREIGN KEY([sequencial_historico])
REFERENCES [dbo].[TB_HistoricoMovimentacao] ([Sequencial_Historico])
ALTER TABLE [dbo].[CaixaAlteracao] CHECK CONSTRAINT [FK_CaixaAlteracao_TB_HistoricoMovimentacao]
