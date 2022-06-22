/****** Object:  Table [dbo].[_backup_lote_comissao_20210526]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[_backup_lote_comissao_20210526](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[dt_cadastro] [datetime] NULL,
	[dt_finalizado] [datetime] NULL,
	[qt_comissoes] [int] NULL,
	[cd_usuario_cadastro] [varchar](50) NULL,
	[vl_total] [money] NULL,
	[cd_funcionario] [int] NULL,
	[dt_lancamento] [datetime] NULL,
	[cd_sequencial_caixa] [int] NULL,
	[dt_base_fim] [datetime] NULL,
	[dt_base_ini] [datetime] NULL,
	[cd_tipo] [smallint] NULL,
	[dt_cancelamento] [datetime] NULL,
	[cd_usuario_cancelamento] [varchar](50) NULL,
	[motivo_cancelamento] [varchar](1000) NULL,
	[vl_total_bruto] [money] NULL,
	[dt_pgto_comissao] [date] NULL,
	[liberadoVisualizacaoVendedor] [bit] NULL,
	[usuarioLiberadoVisualizacaoVendedor] [int] NULL,
	[usuarioOcultadoVisualizacaoVendedor] [int] NULL,
	[dataLiberadoVisualizacaoVendedor] [datetime] NULL,
	[dataOcultadoVisualizacaoVendedor] [datetime] NULL,
	[executarTrigger] [bit] NULL
) ON [PRIMARY]
