/****** Object:  Table [dbo].[TabelaServicosHistoricoExclusao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TabelaServicosHistoricoExclusao](
	[id] [int] NULL,
	[cd_tabela_servicos] [int] NULL,
	[dataHistorico] [datetime] NULL,
	[usuarioHistorico] [int] NULL,
	[operacaoHistorico] [int] NULL,
	[nm_usuarioAlteracao] [varchar](100) NULL,
	[tipoMoedaCalculo] [tinyint] NULL,
	[vl_servico] [money] NULL,
	[cd_servico] [int] NULL,
	[cd_especialidade] [int] NULL,
	[ds_tabela] [varchar](100) NULL,
	[nm_servico] [varchar](200) NULL,
	[nm_especialidade] [nchar](60) NULL,
	[valorAntigo] [varchar](10) NULL,
	[novoValor] [varchar](10) NULL,
	[cd_tabelaExclusao] [int] NULL
) ON [PRIMARY]
