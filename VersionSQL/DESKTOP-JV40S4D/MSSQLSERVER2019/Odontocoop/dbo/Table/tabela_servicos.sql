/****** Object:  Table [dbo].[tabela_servicos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tabela_servicos](
	[cd_tabela_servicos] [int] IDENTITY(1,1) NOT NULL,
	[cd_tabela] [smallint] NOT NULL,
	[cd_servico] [int] NULL,
	[vl_servico] [money] NOT NULL,
	[cd_plano] [smallint] NULL,
	[cd_tabela_referencia] [int] NULL,
	[cd_especialidade] [int] NULL,
	[tipoMoedaCalculo] [tinyint] NULL,
	[dataAlteracao] [datetime] NULL,
	[usuarioAlteracao] [int] NULL,
	[operacaoAlteracao] [int] NULL,
	[cdTabelaReferenciaAnterior] [int] NULL,
	[valorDesconto] [money] NULL,
	[tipoValorDesconto] [int] NULL,
 CONSTRAINT [PK_tabela_servicos] PRIMARY KEY CLUSTERED 
(
	[cd_tabela_servicos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_tabela_servicos_7_692874231__K5_K3_K2_K6_K1_K7_4] ON [dbo].[tabela_servicos]
(
	[cd_plano] ASC,
	[cd_servico] ASC,
	[cd_tabela] ASC,
	[cd_tabela_referencia] ASC,
	[cd_tabela_servicos] ASC,
	[cd_especialidade] ASC
)
INCLUDE([vl_servico]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_tabela_servicos_7_692874231__K6_K3_K7_K5_K1_K2_4] ON [dbo].[tabela_servicos]
(
	[cd_tabela_referencia] ASC,
	[cd_servico] ASC,
	[cd_especialidade] ASC,
	[cd_plano] ASC,
	[cd_tabela_servicos] ASC,
	[cd_tabela] ASC
)
INCLUDE([vl_servico]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_tabela_servicos_7_692874231__K7_K6_K2_K3_1_4] ON [dbo].[tabela_servicos]
(
	[cd_especialidade] ASC,
	[cd_tabela_referencia] ASC,
	[cd_tabela] ASC,
	[cd_servico] ASC
)
INCLUDE([cd_tabela_servicos],[vl_servico]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tabela_servicos] ON [dbo].[tabela_servicos]
(
	[cd_tabela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tabela_servicos_1] ON [dbo].[tabela_servicos]
(
	[cd_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE UNIQUE NONCLUSTERED INDEX [IX_tabela_servicos_3] ON [dbo].[tabela_servicos]
(
	[cd_tabela] ASC,
	[cd_plano] ASC,
	[cd_servico] ASC,
	[cd_tabela_referencia] ASC,
	[cd_especialidade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
EXEC sys.sp_addextendedproperty @name=N'descricao_tabela_servico_dataAlteracao', @value=N'Data da alteração' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tabela_servicos', @level2type=N'COLUMN',@level2name=N'dataAlteracao'
EXEC sys.sp_addextendedproperty @name=N'descricao_tabela_servico_usuarioAlteracao', @value=N'Usuário que realizou a alteracao do registro no sistema' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tabela_servicos', @level2type=N'COLUMN',@level2name=N'usuarioAlteracao'
EXEC sys.sp_addextendedproperty @name=N'descricao_tabela_servico_operacaoAlteracao', @value=N'Operação que aconteceu na alteração' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tabela_servicos', @level2type=N'COLUMN',@level2name=N'operacaoAlteracao'
EXEC sys.sp_addextendedproperty @name=N'descricao_tabela_servico_cdTabelaReferenciaAnterior', @value=N'Identifica a tabela referencia anterior' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tabela_servicos', @level2type=N'COLUMN',@level2name=N'cdTabelaReferenciaAnterior'
