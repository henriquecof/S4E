/****** Object:  Table [dbo].[tbAutorizacaoConsulta]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tbAutorizacaoConsulta](
	[acoId] [int] IDENTITY(1,1) NOT NULL,
	[cd_associado] [int] NULL,
	[cd_sequencial_dep] [smallint] NULL,
	[cd_funcionario] [int] NOT NULL,
	[acoMotivo] [varchar](500) NOT NULL,
	[acoDtLimite] [datetime] NOT NULL,
	[acoDtCadastro] [datetime] NOT NULL,
	[acoDtUtilizacao] [datetime] NULL,
	[cd_empresa] [int] NULL,
	[acoDtVencimentoFatura] [datetime] NULL,
	[acoUrgencia] [bit] NULL,
	[acoDtExclusao] [datetime] NULL,
 CONSTRAINT [PK_tbAutorizacaoConsulta] PRIMARY KEY CLUSTERED 
(
	[acoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_tbAutorizacaoConsulta] ON [dbo].[tbAutorizacaoConsulta]
(
	[cd_associado] ASC,
	[cd_sequencial_dep] ASC,
	[acoDtLimite] ASC,
	[acoDtUtilizacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tbAutorizacaoConsulta_3] ON [dbo].[tbAutorizacaoConsulta]
(
	[cd_empresa] ASC,
	[acoDtVencimentoFatura] ASC,
	[acoDtLimite] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Associado|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbAutorizacaoConsulta', @level2type=N'COLUMN',@level2name=N'cd_associado'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dependente' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbAutorizacaoConsulta', @level2type=N'COLUMN',@level2name=N'cd_sequencial_dep'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Funcionário' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbAutorizacaoConsulta', @level2type=N'COLUMN',@level2name=N'cd_funcionario'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Motivo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbAutorizacaoConsulta', @level2type=N'COLUMN',@level2name=N'acoMotivo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'data Limite' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbAutorizacaoConsulta', @level2type=N'COLUMN',@level2name=N'acoDtLimite'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Cadastro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbAutorizacaoConsulta', @level2type=N'COLUMN',@level2name=N'acoDtCadastro'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Utilização' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbAutorizacaoConsulta', @level2type=N'COLUMN',@level2name=N'acoDtUtilizacao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empresa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbAutorizacaoConsulta', @level2type=N'COLUMN',@level2name=N'cd_empresa'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Vencimento Fatura' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbAutorizacaoConsulta', @level2type=N'COLUMN',@level2name=N'acoDtVencimentoFatura'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Urgência' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbAutorizacaoConsulta', @level2type=N'COLUMN',@level2name=N'acoUrgencia'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Exclusão' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbAutorizacaoConsulta', @level2type=N'COLUMN',@level2name=N'acoDtExclusao'
