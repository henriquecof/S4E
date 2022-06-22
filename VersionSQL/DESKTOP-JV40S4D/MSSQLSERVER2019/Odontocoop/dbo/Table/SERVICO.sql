/****** Object:  Table [dbo].[SERVICO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SERVICO](
	[CD_SERVICO] [int] NOT NULL,
	[NM_SERVICO] [varchar](200) NULL,
	[tp_procedimento] [smallint] NOT NULL,
	[cd_exigedocumentacao] [bit] NOT NULL,
	[cd_naoapresentaodontograma] [bit] NOT NULL,
	[cd_naoaceitapendente] [bit] NOT NULL,
	[fl_urgencia] [bit] NOT NULL,
	[fl_aceitainclusaodireta] [bit] NOT NULL,
	[fl_urgencia_noturna] [bit] NOT NULL,
	[cd_servico_antigo] [varchar](200) NULL,
	[fl_ApresentaProdutividade] [bit] NOT NULL,
	[fl_DesprezaMarcacao] [bit] NOT NULL,
	[fl_ContagemBaixaAgenda] [bit] NOT NULL,
	[cd_especialidadereferencia] [int] NOT NULL,
	[qt_face_dente] [tinyint] NULL,
	[fl_exige_dente] [bit] NULL,
	[fl_recorrente] [bit] NULL,
	[cd_peso] [float] NULL,
	[fl_restringePericia] [bit] NULL,
	[cd_servicoANS] [int] NULL,
	[vl_us] [money] NULL,
	[cd_tabelaANS] [varchar](2) NULL,
	[fl_IncluirCorrelacionados] [bit] NULL,
	[fl_BaixaFinalOdontograma] [bit] NULL,
	[cd_grupo] [int] NULL,
	[qt_peso_sip] [smallint] NULL,
	[cd_Servico_coparticipado] [int] NULL,
	[realizacaoQualquerPrestador] [tinyint] NULL,
	[aceitaOrcamento] [bit] NULL,
	[qtDiasBloqueio] [int] NULL,
	[baixarApenasAposUpload] [bit] NULL,
	[lancarApenasComEspecialidade] [bit] NULL,
	[procedimentosCorrelacionados] [varchar](max) NULL,
	[cd_tipo_documentacao] [smallint] NULL,
	[dente] [bit] NULL,
	[solicitanteLancamento] [tinyint] NULL,
	[idTipoAnaliseAuditoria] [tinyint] NULL,
	[realizarAposLiberacaoManual] [bit] NULL,
	[permiteDuplicadoGto] [bit] NULL,
	[permiteDuplicadoProdutividadeAndamento] [bit] NULL,
	[liberadoAutomaticamenteRealizacao] [bit] NULL,
	[periciaFinal] [bit] NULL,
	[menuNecessidades] [bit] NULL,
	[exigeLaboratorioProtese] [bit] NULL,
	[permiteEmDentesAusentes] [bit] NULL,
	[tempoMinutosMedioRealizacao] [float] NULL,
	[flanalisaProcedimentoPag] [bit] NULL,
	[idGrupoTratamento] [int] NULL,
	[desmembraCorrelacionados] [tinyint] NULL,
 CONSTRAINT [PK_SERVICO] PRIMARY KEY NONCLUSTERED 
(
	[CD_SERVICO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_SERVICO] ON [dbo].[SERVICO]
(
	[NM_SERVICO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_SERVICO_1] ON [dbo].[SERVICO]
(
	[cd_servicoANS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_servico_cd_servicoANS] ON [dbo].[SERVICO]
(
	[cd_servicoANS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[SERVICO] ADD  CONSTRAINT [DF_SERVICO_cd_exigedocumentacao]  DEFAULT ((0)) FOR [cd_exigedocumentacao]
ALTER TABLE [dbo].[SERVICO] ADD  CONSTRAINT [DF_SERVICO_cd_naoapresentaodontograma]  DEFAULT ((0)) FOR [cd_naoapresentaodontograma]
ALTER TABLE [dbo].[SERVICO] ADD  CONSTRAINT [DF_SERVICO_cd_naoaceitapendente]  DEFAULT ((0)) FOR [cd_naoaceitapendente]
ALTER TABLE [dbo].[SERVICO] ADD  CONSTRAINT [DF_SERVICO_fl_urgencia]  DEFAULT ((0)) FOR [fl_urgencia]
ALTER TABLE [dbo].[SERVICO] ADD  CONSTRAINT [DF_SERVICO_fl_incluirodontograma]  DEFAULT ((0)) FOR [fl_aceitainclusaodireta]
ALTER TABLE [dbo].[SERVICO] ADD  CONSTRAINT [DF_SERVICO_fl_ApresentaProdutividade]  DEFAULT ((1)) FOR [fl_ApresentaProdutividade]
ALTER TABLE [dbo].[SERVICO] ADD  CONSTRAINT [DF_SERVICO_fl_DesprezaMarcacao]  DEFAULT ((0)) FOR [fl_DesprezaMarcacao]
ALTER TABLE [dbo].[SERVICO]  WITH CHECK ADD  CONSTRAINT [FK_SERVICO_GrupoTratamento] FOREIGN KEY([idGrupoTratamento])
REFERENCES [dbo].[GrupoTratamento] ([idGrupoTratamento])
ALTER TABLE [dbo].[SERVICO] CHECK CONSTRAINT [FK_SERVICO_GrupoTratamento]
ALTER TABLE [dbo].[SERVICO]  WITH NOCHECK ADD  CONSTRAINT [FK_SERVICO_tipo_procedimento] FOREIGN KEY([tp_procedimento])
REFERENCES [dbo].[tipo_procedimento] ([tp_procedimento])
ALTER TABLE [dbo].[SERVICO] CHECK CONSTRAINT [FK_SERVICO_tipo_procedimento]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Código' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SERVICO', @level2type=N'COLUMN',@level2name=N'CD_SERVICO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Serviço' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SERVICO', @level2type=N'COLUMN',@level2name=N'NM_SERVICO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SERVICO', @level2type=N'COLUMN',@level2name=N'tp_procedimento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Documentação' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SERVICO', @level2type=N'COLUMN',@level2name=N'cd_exigedocumentacao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Oculto' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SERVICO', @level2type=N'COLUMN',@level2name=N'cd_naoapresentaodontograma'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Não Aceita Pendente' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SERVICO', @level2type=N'COLUMN',@level2name=N'cd_naoaceitapendente'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Urgência' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SERVICO', @level2type=N'COLUMN',@level2name=N'fl_urgencia'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Inclusão Direta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SERVICO', @level2type=N'COLUMN',@level2name=N'fl_aceitainclusaodireta'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Urgência Noturna' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SERVICO', @level2type=N'COLUMN',@level2name=N'fl_urgencia_noturna'
EXEC sys.sp_addextendedproperty @name=N'Modulo', @value=N'Cadastro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SERVICO'
EXEC sys.sp_addextendedproperty @name=N'Permissao', @value=N'5' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SERVICO'
