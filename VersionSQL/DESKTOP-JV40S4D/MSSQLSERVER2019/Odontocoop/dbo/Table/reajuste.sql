/****** Object:  Table [dbo].[reajuste]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[reajuste](
	[id_reajuste] [int] IDENTITY(1,1) NOT NULL,
	[cd_empresa] [bigint] NOT NULL,
	[dt_reajuste] [datetime] NOT NULL,
	[cd_usuario] [int] NOT NULL,
	[perc_reajuste] [float] NOT NULL,
	[dt_aplicado_reajuste] [datetime] NULL,
	[fl_moeda] [bit] NOT NULL,
	[dt_executado_reajuste] [datetime] NULL,
	[cd_sequencial_pplano] [int] NULL,
	[mes_assinatura] [tinyint] NULL,
	[dt_referencia_reajuste_pf] [date] NULL,
	[qt_vidas] [int] NULL,
	[CriterioTecnico] [varchar](max) NULL,
	[MemoriaCalculo] [varchar](max) NULL,
	[dataObservacaoInicial] [datetime] NULL,
	[dataObservacaoFinal] [datetime] NULL,
	[anoIndice] [varchar](4) NULL,
	[idIndiceReajuste] [int] NULL,
	[PercentualSemReajuste] [float] NULL,
	[EnviaAlerta] [tinyint] NULL,
	[cd_situacaoAssociado] [smallint] NULL,
	[incluirBeneficiariosInativos] [bit] NULL,
 CONSTRAINT [PK_reajuste_2007] PRIMARY KEY CLUSTERED 
(
	[id_reajuste] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [IX_reajuste] ON [dbo].[reajuste]
(
	[id_reajuste] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[reajuste]  WITH CHECK ADD  CONSTRAINT [FK_reajuste_EMPRESA] FOREIGN KEY([cd_empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ON UPDATE CASCADE
ALTER TABLE [dbo].[reajuste] CHECK CONSTRAINT [FK_reajuste_EMPRESA]
ALTER TABLE [dbo].[reajuste]  WITH CHECK ADD  CONSTRAINT [FK_reajuste_idIndiceReajuste_IndiceReajuste_id] FOREIGN KEY([idIndiceReajuste])
REFERENCES [dbo].[IndiceReajuste] ([id])
ALTER TABLE [dbo].[reajuste] CHECK CONSTRAINT [FK_reajuste_idIndiceReajuste_IndiceReajuste_id]
ALTER TABLE [dbo].[reajuste]  WITH CHECK ADD  CONSTRAINT [FK_reajuste_preco_plano] FOREIGN KEY([cd_sequencial_pplano])
REFERENCES [dbo].[preco_plano] ([cd_sequencial])
ALTER TABLE [dbo].[reajuste] CHECK CONSTRAINT [FK_reajuste_preco_plano]
ALTER TABLE [dbo].[reajuste]  WITH CHECK ADD  CONSTRAINT [FK_reajuste_SITUACAO_HISTORICO] FOREIGN KEY([cd_situacaoAssociado])
REFERENCES [dbo].[SITUACAO_HISTORICO] ([CD_SITUACAO_HISTORICO])
ALTER TABLE [dbo].[reajuste] CHECK CONSTRAINT [FK_reajuste_SITUACAO_HISTORICO]
