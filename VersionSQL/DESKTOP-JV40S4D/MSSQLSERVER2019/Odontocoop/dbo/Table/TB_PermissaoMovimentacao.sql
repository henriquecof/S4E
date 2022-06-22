/****** Object:  Table [dbo].[TB_PermissaoMovimentacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_PermissaoMovimentacao](
	[Sequencial_Permissao] [int] IDENTITY(1,1) NOT NULL,
	[CD_Funcionario] [int] NOT NULL,
	[Sequencial_Movimentacao] [int] NOT NULL,
	[nome_usuario] [varchar](20) NOT NULL,
 CONSTRAINT [PK_TB_PermissaoMovimentacao] PRIMARY KEY CLUSTERED 
(
	[Sequencial_Permissao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [IX_TB_PermissaoMovimentacao] ON [dbo].[TB_PermissaoMovimentacao]
(
	[Sequencial_Movimentacao] ASC,
	[CD_Funcionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TB_PermissaoMovimentacao]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_PermissaoMovimentacao_TB_MovimentacaoFinanceira] FOREIGN KEY([Sequencial_Movimentacao])
REFERENCES [dbo].[TB_MovimentacaoFinanceira] ([Sequencial_Movimentacao])
ALTER TABLE [dbo].[TB_PermissaoMovimentacao] CHECK CONSTRAINT [FK_TB_PermissaoMovimentacao_TB_MovimentacaoFinanceira]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_PermissaoMovimentacao', @level2type=N'COLUMN',@level2name=N'Sequencial_Permissao'
