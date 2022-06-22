/****** Object:  Table [dbo].[DEPENDENTES]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DEPENDENTES](
	[CD_SEQUENCIAL] [int] NOT NULL,
	[CD_ASSOCIADO] [int] NOT NULL,
	[NM_DEPENDENTE] [nvarchar](100) NULL,
	[dt_assinaturaContrato] [datetime] NOT NULL,
	[CD_GRAU_PARENTESCO] [smallint] NOT NULL,
	[DT_NASCIMENTO] [smalldatetime] NULL,
	[fl_sexo] [bit] NOT NULL,
	[CD_Sequencial_historico] [int] NULL,
	[mm_aaaa_1pagamento] [int] NOT NULL,
	[cd_plano] [smallint] NOT NULL,
	[vl_plano] [money] NOT NULL,
	[cd_funcionario_vendedor] [int] NULL,
	[cd_funcionario_dentista] [int] NULL,
	[nr_cpf_dep] [varchar](11) NULL,
	[nm_mae_dep] [varchar](80) NULL,
	[nr_sus] [nvarchar](20) NULL,
	[nr_contrato] [int] NULL,
	[dt_atualizacao_email] [datetime] NULL,
	[nr_periodicidade] [smallint] NULL,
	[nr_parcelas] [smallint] NULL,
	[cd_Sequencialdependente] [int] NULL,
	[cd_gerou_adesao] [smallint] NULL,
	[cd_situacao] [int] NULL,
	[fl_BiometricoObrigatorio] [bit] NULL,
	[fl_CarenciaAtendimento] [tinyint] NOT NULL,
	[cco] [varchar](12) NULL,
	[nr_cns] [varchar](50) NULL,
	[dt_RecKitOrto] [datetime] NULL,
	[cd_clinica] [int] NULL,
	[dt_agendamentoPre] [varchar](300) NULL,
	[dt_impressoPre] [datetime] NULL,
	[dt_recebidoPre] [datetime] NULL,
	[dt_PagamentoAdesao] [datetime] NULL,
	[cd_tipo_rede_atendimento] [tinyint] NULL,
	[fl_foto] [bit] NULL,
	[cd_beneficiario_ans] [varchar](50) NULL,
	[nr_carteira] [varchar](20) NULL,
	[Sq_lote_carteira] [int] NULL,
	[rcaId] [int] NULL,
	[Observacao] [varchar](500) NULL,
	[dn_nascidovivo] [varchar](50) NULL,
	[dt_reajuste] [date] NULL,
	[cd_funcionario_cadastro] [int] NULL,
	[cd_funcionario_adesionista] [int] NULL,
	[dt_situacao] [date] NULL,
	[cd_vendedor] [int] NULL,
	[nm_vendedor] [varchar](50) NULL,
	[tmiId] [tinyint] NULL,
	[data_protocolo_contrato] [datetime] NULL,
	[dt_inicio_cobertura] [datetime] NULL,
	[alias_interno] [varchar](50) NULL,
	[senha] [varchar](50) NULL,
	[dt_alteracao_senha] [datetime] NULL,
	[executarTrigger] [bit] NULL,
	[codigoParceiro] [int] NULL,
	[parceiroPlanoOdontologico] [bit] NULL,
	[cd_tipoautorizador] [tinyint] NULL,
	[dt_venda] [datetime] NULL,
	[id_raca] [int] NULL,
	[especie] [int] NULL,
	[peso] [decimal](18, 0) NULL,
	[cd_sistema_externo] [varchar](50) NULL,
	[cd_sistema_antigo] [varchar](50) NULL,
	[cd_funcionario_repasse] [int] NULL,
	[NomeSocial] [nvarchar](60) NULL,
	[utilizaNomeSocial] [bit] NULL,
	[chave] [varchar](50) NULL,
	[Naturalidade] [int] NULL,
	[estadoCivil] [tinyint] NULL,
	[dtAdmissao] [date] NULL,
	[dtCasamento] [date] NULL,
	[Voucher] [varchar](100) NULL,
	[qtdManutencaoOrtodontica] [smallint] NULL,
	[fl_vip] [smallint] NULL,
	[qtdeMaximaBaixaUsuarioMes] [tinyint] NULL,
	[formacaoPreco] [tinyint] NULL,
	[validade] [smalldatetime] NULL,
	[ih] [varchar](10) NULL,
	[classificaoRetorno] [int] NULL,
	[dt_atualizacao] [datetime] NULL,
	[DT_CD_CLASSIFICACAO_RETORNO_DEP] [datetime] NULL,
	[nr_identidade] [varchar](20) NULL,
	[nm_orgaoexp] [varchar](10) NULL,
 CONSTRAINT [PK_DEPENDENTES_1] PRIMARY KEY CLUSTERED 
(
	[CD_SEQUENCIAL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_DEPENDENTES] ON [dbo].[DEPENDENTES]
(
	[CD_GRAU_PARENTESCO] ASC,
	[CD_ASSOCIADO] ASC,
	[cd_plano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_DEPENDENTES_34_1039303458__K1_K14_K10_K2_K12_K17_K8_3_5_6_9_15_22_29] ON [dbo].[DEPENDENTES]
(
	[CD_SEQUENCIAL] ASC,
	[nr_cpf_dep] ASC,
	[cd_plano] ASC,
	[CD_ASSOCIADO] ASC,
	[cd_funcionario_vendedor] ASC,
	[nr_contrato] ASC,
	[CD_Sequencial_historico] ASC
)
INCLUDE([NM_DEPENDENTE],[CD_GRAU_PARENTESCO],[DT_NASCIMENTO],[mm_aaaa_1pagamento],[nm_mae_dep],[cd_gerou_adesao],[cd_clinica]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_DEPENDENTES_34_1039303458__K14_K1_K2_K10_K12_K17_K8_3_5_6_9_15_22_29] ON [dbo].[DEPENDENTES]
(
	[nr_cpf_dep] ASC,
	[CD_SEQUENCIAL] ASC,
	[CD_ASSOCIADO] ASC,
	[cd_plano] ASC,
	[cd_funcionario_vendedor] ASC,
	[nr_contrato] ASC,
	[CD_Sequencial_historico] ASC
)
INCLUDE([NM_DEPENDENTE],[CD_GRAU_PARENTESCO],[DT_NASCIMENTO],[mm_aaaa_1pagamento],[nm_mae_dep],[cd_gerou_adesao],[cd_clinica]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_DEPENDENTES_36_1669385512__K2_K5_K8_K10_K1_3_4_6_14_15_26_37] ON [dbo].[DEPENDENTES]
(
	[CD_ASSOCIADO] ASC,
	[CD_GRAU_PARENTESCO] ASC,
	[CD_Sequencial_historico] ASC,
	[cd_plano] ASC,
	[CD_SEQUENCIAL] ASC
)
INCLUDE([NM_DEPENDENTE],[dt_assinaturaContrato],[DT_NASCIMENTO],[nr_cpf_dep],[nm_mae_dep],[cco],[nr_carteira]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_DEPENDENTES_36_1669385512__K5_K8_2_3] ON [dbo].[DEPENDENTES]
(
	[CD_GRAU_PARENTESCO] ASC,
	[CD_Sequencial_historico] ASC
)
INCLUDE([CD_ASSOCIADO],[NM_DEPENDENTE]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_DEPENDENTES_5_1669385512__K10_K2] ON [dbo].[DEPENDENTES]
(
	[cd_plano] ASC,
	[CD_ASSOCIADO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_DEPENDENTES_5_1669385512__K30_K8_K12_K32_K31] ON [dbo].[DEPENDENTES]
(
	[dt_agendamentoPre] ASC,
	[CD_Sequencial_historico] ASC,
	[cd_funcionario_vendedor] ASC,
	[dt_recebidoPre] ASC,
	[dt_impressoPre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_DEPENDENTES_5_1669385512__K5_K2_K1_K8_11] ON [dbo].[DEPENDENTES]
(
	[CD_GRAU_PARENTESCO] ASC,
	[CD_ASSOCIADO] ASC,
	[CD_SEQUENCIAL] ASC,
	[CD_Sequencial_historico] ASC
)
INCLUDE([vl_plano]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_DEPENDENTES_5_1669385512__K5_K2_K8] ON [dbo].[DEPENDENTES]
(
	[CD_GRAU_PARENTESCO] ASC,
	[CD_ASSOCIADO] ASC,
	[CD_Sequencial_historico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_DEPENDENTES_5_1669385512__K8_K30_K12_K32_K31] ON [dbo].[DEPENDENTES]
(
	[CD_Sequencial_historico] ASC,
	[dt_agendamentoPre] ASC,
	[cd_funcionario_vendedor] ASC,
	[dt_recebidoPre] ASC,
	[dt_impressoPre] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_DEPENDENTES_56_667878192__K26_K5_K3_K6_K41] ON [dbo].[DEPENDENTES]
(
	[cco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_DEPENDENTES_7_1504580994__K1_K2] ON [dbo].[DEPENDENTES]
(
	[CD_SEQUENCIAL] ASC,
	[CD_ASSOCIADO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_DEPENDENTES] ON [dbo].[DEPENDENTES]
(
	[nr_cpf_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_DEPENDENTES_1] ON [dbo].[DEPENDENTES]
(
	[NM_DEPENDENTE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_DEPENDENTES_10] ON [dbo].[DEPENDENTES]
(
	[CD_GRAU_PARENTESCO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_DEPENDENTES_11] ON [dbo].[DEPENDENTES]
(
	[cd_sistema_antigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_DEPENDENTES_12] ON [dbo].[DEPENDENTES]
(
	[cd_sistema_externo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_DEPENDENTES_2] ON [dbo].[DEPENDENTES]
(
	[CD_ASSOCIADO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_DEPENDENTES_3] ON [dbo].[DEPENDENTES]
(
	[cd_clinica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_DEPENDENTES_4] ON [dbo].[DEPENDENTES]
(
	[cd_funcionario_dentista] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_DEPENDENTES_5] ON [dbo].[DEPENDENTES]
(
	[cd_plano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_DEPENDENTES_6] ON [dbo].[DEPENDENTES]
(
	[CD_Sequencial_historico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_DEPENDENTES_7] ON [dbo].[DEPENDENTES]
(
	[dt_assinaturaContrato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_DEPENDENTES_8] ON [dbo].[DEPENDENTES]
(
	[DT_NASCIMENTO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_DEPENDENTES_9] ON [dbo].[DEPENDENTES]
(
	[dt_PagamentoAdesao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Dependentes_cd_associado] ON [dbo].[DEPENDENTES]
(
	[CD_ASSOCIADO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[DEPENDENTES] ADD  CONSTRAINT [DF_DEPENDENTES_fl_BiometricoObrigatorio]  DEFAULT ((1)) FOR [fl_BiometricoObrigatorio]
ALTER TABLE [dbo].[DEPENDENTES]  WITH CHECK ADD  CONSTRAINT [FK__DEPENDENT__id_ra__10D75A96] FOREIGN KEY([id_raca])
REFERENCES [dbo].[Raca] ([id])
ALTER TABLE [dbo].[DEPENDENTES] CHECK CONSTRAINT [FK__DEPENDENT__id_ra__10D75A96]
ALTER TABLE [dbo].[DEPENDENTES]  WITH NOCHECK ADD  CONSTRAINT [FK_DEPENDENTES_ASSOCIADOS] FOREIGN KEY([CD_ASSOCIADO])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[DEPENDENTES] CHECK CONSTRAINT [FK_DEPENDENTES_ASSOCIADOS]
ALTER TABLE [dbo].[DEPENDENTES]  WITH NOCHECK ADD  CONSTRAINT [FK_DEPENDENTES_Clinica] FOREIGN KEY([cd_clinica])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[DEPENDENTES] CHECK CONSTRAINT [FK_DEPENDENTES_Clinica]
ALTER TABLE [dbo].[DEPENDENTES]  WITH NOCHECK ADD  CONSTRAINT [FK_DEPENDENTES_GRAU_PARENTESCO] FOREIGN KEY([CD_GRAU_PARENTESCO])
REFERENCES [dbo].[GRAU_PARENTESCO] ([cd_grau_parentesco])
ALTER TABLE [dbo].[DEPENDENTES] CHECK CONSTRAINT [FK_DEPENDENTES_GRAU_PARENTESCO]
ALTER TABLE [dbo].[DEPENDENTES]  WITH CHECK ADD  CONSTRAINT [FK_Dependentes_TipoMidia] FOREIGN KEY([tmiId])
REFERENCES [dbo].[TipoMidia] ([tmiId])
ALTER TABLE [dbo].[DEPENDENTES] CHECK CONSTRAINT [FK_Dependentes_TipoMidia]
ALTER TABLE [dbo].[DEPENDENTES]  WITH NOCHECK ADD  CONSTRAINT [FK_DEPENDENTES_TipoRedeAtendimento] FOREIGN KEY([cd_tipo_rede_atendimento])
REFERENCES [dbo].[TipoRedeAtendimento] ([cd_tipo_rede_atendimento])
ALTER TABLE [dbo].[DEPENDENTES] CHECK CONSTRAINT [FK_DEPENDENTES_TipoRedeAtendimento]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Associado' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'CD_ASSOCIADO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dependente|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'NM_DEPENDENTE'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Assinatura' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'dt_assinaturaContrato'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parentesco|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'CD_GRAU_PARENTESCO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nascimento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'DT_NASCIMENTO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sexo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'fl_sexo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Histórico' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'CD_Sequencial_historico'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Plano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'cd_plano'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor Plano' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'vl_plano'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vendedor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'cd_funcionario_vendedor'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dentista' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'cd_funcionario_dentista'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CPF Dependente' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'nr_cpf_dep'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nome da Mãe' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'nm_mae_dep'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SUS' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'nr_sus'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contrato' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'nr_contrato'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Atualização Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'dt_atualizacao_email'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Periodicidade' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'nr_periodicidade'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parcelas' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DEPENDENTES', @level2type=N'COLUMN',@level2name=N'nr_parcelas'
