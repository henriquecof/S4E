/****** Object:  Table [dbo].[PLANOS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PLANOS](
	[cd_plano] [int] IDENTITY(1,1) NOT NULL,
	[nm_plano] [varchar](100) NOT NULL,
	[cd_classificacao] [smallint] NULL,
	[perc_coparticipacao] [int] NULL,
	[cd_tabelaparticular] [int] NULL,
	[qt_atendimentoconsulta] [int] NOT NULL,
	[dt_fim_comercializacao] [datetime] NULL,
	[fl_exige_dentista] [bit] NOT NULL,
	[fl_cortesia] [bit] NOT NULL,
	[QT_DIAS_BLOQUEIO_ATENDIMENTO] [smallint] NOT NULL,
	[fl_CarenciaAtendimentoPlano] [bit] NOT NULL,
	[QT_DIAS_BLOQUEIO_ATENDIMENTOU] [smallint] NULL,
	[cd_tipo_plano] [smallint] NOT NULL,
	[observacao] [varchar](500) NULL,
	[cd_centro_custo] [smallint] NULL,
	[qt_DiasProxMarcacaoConsulta] [smallint] NULL,
	[qt_BaixasProcedimentosMes] [tinyint] NULL,
	[end_LayoutCarteira] [varchar](50) NULL,
	[fl_ativo] [bit] NULL,
	[tipo_aceita_venda] [tinyint] NULL,
	[cd_empresaExclusivo] [int] NULL,
	[cd_associadoExclusivo] [int] NULL,
	[nm_reduzido] [varchar](50) NULL,
	[qt_dias_bloqueio_atendimento_orto] [smallint] NULL,
	[numeroParcelasMax] [tinyint] NULL,
	[valorMinimoParcela] [money] NULL,
	[validadeCredito] [tinyint] NULL,
	[valorTotalPlano] [money] NULL,
	[modeloFixo] [bit] NULL,
	[idTextoContratos] [int] NULL,
	[parceiroPlanoOdontologico] [bit] NULL,
	[cd_produto] [varchar](13) NULL,
	[fl_exige_dentista_cadastro] [bit] NULL,
	[fl_visualizacao_ficha_clinica] [bit] NULL,
	[controleCarencia] [bit] NULL,
	[cd_planoReferencia] [smallint] NULL,
	[PlanoProposta] [int] NULL,
	[fl_comercial] [bit] NULL,
	[utilizaDiasBloqueioAtendimento] [bit] NULL,
	[ordem] [tinyint] NULL,
	[fl_gera_carteiraPlano] [smallint] NULL,
	[taxaAdm] [money] NULL,
	[exibirRedeAtendimento] [bit] NULL,
	[QtdeBaixaPlanoUsuario] [tinyint] NULL,
	[ReferenciaLimiteBaixaPlanoUsuario] [tinyint] NULL,
	[acomodacao] [varchar](100) NULL,
	[abrangencia] [varchar](100) NULL,
	[preenchimentoSenhaConvenioAutorizador] [bit] NULL,
	[usaCreditoBaixaOrto] [bit] NULL,
 CONSTRAINT [PK_PLANOS] PRIMARY KEY NONCLUSTERED 
(
	[cd_plano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PLANOS]  WITH NOCHECK ADD  CONSTRAINT [FK_PLANOS_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[PLANOS] CHECK CONSTRAINT [FK_PLANOS_Centro_Custo]
ALTER TABLE [dbo].[PLANOS]  WITH NOCHECK ADD  CONSTRAINT [FK_PLANOS_CLASSIFICACAO_ANS] FOREIGN KEY([cd_classificacao])
REFERENCES [dbo].[CLASSIFICACAO_ANS] ([cd_classificacao])
ALTER TABLE [dbo].[PLANOS] CHECK CONSTRAINT [FK_PLANOS_CLASSIFICACAO_ANS]
ALTER TABLE [dbo].[PLANOS]  WITH NOCHECK ADD  CONSTRAINT [FK_PLANOS_Tabela] FOREIGN KEY([cd_tabelaparticular])
REFERENCES [dbo].[Tabela] ([cd_tabela])
ALTER TABLE [dbo].[PLANOS] CHECK CONSTRAINT [FK_PLANOS_Tabela]
ALTER TABLE [dbo].[PLANOS]  WITH CHECK ADD  CONSTRAINT [FK_PLANOS_TextoContratos] FOREIGN KEY([idTextoContratos])
REFERENCES [dbo].[TextoContratos] ([id])
ALTER TABLE [dbo].[PLANOS] CHECK CONSTRAINT [FK_PLANOS_TextoContratos]
ALTER TABLE [dbo].[PLANOS]  WITH NOCHECK ADD  CONSTRAINT [FK_PLANOS_tipo_plano] FOREIGN KEY([cd_tipo_plano])
REFERENCES [dbo].[tipo_plano] ([cd_tipo_plano])
ALTER TABLE [dbo].[PLANOS] CHECK CONSTRAINT [FK_PLANOS_tipo_plano]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PLANOS', @level2type=N'COLUMN',@level2name=N'cd_plano'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Plano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PLANOS', @level2type=N'COLUMN',@level2name=N'nm_plano'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Classificação ANS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PLANOS', @level2type=N'COLUMN',@level2name=N'cd_classificacao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Percentual Co-Participação' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PLANOS', @level2type=N'COLUMN',@level2name=N'perc_coparticipacao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tabela Particular' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PLANOS', @level2type=N'COLUMN',@level2name=N'cd_tabelaparticular'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Qtde de Procedimentos Consulta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PLANOS', @level2type=N'COLUMN',@level2name=N'qt_atendimentoconsulta'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Fim Comercialização' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PLANOS', @level2type=N'COLUMN',@level2name=N'dt_fim_comercializacao'
