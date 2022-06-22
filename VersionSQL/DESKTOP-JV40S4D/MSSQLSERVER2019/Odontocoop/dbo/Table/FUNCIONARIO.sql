/****** Object:  Table [dbo].[FUNCIONARIO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[FUNCIONARIO](
	[cd_funcionario] [int] IDENTITY(1,1) NOT NULL,
	[nm_empregado] [varchar](100) NULL,
	[cd_tabela] [int] NULL,
	[LogCep] [varchar](8) NULL,
	[CHAVE_TIPOLOGRADOURO] [int] NULL,
	[EndLogradouro] [varchar](100) NULL,
	[EndNumero] [int] NULL,
	[EndComplemento] [varchar](100) NULL,
	[BaiId] [int] NULL,
	[CidID] [int] NULL,
	[ufId] [smallint] NULL,
	[nr_cpf] [varchar](11) NULL,
	[nr_identidade] [varchar](14) NULL,
	[nm_orgaoexp] [varchar](6) NULL,
	[cd_cargo] [smallint] NULL,
	[cd_equipe] [smallint] NULL,
	[cro] [varchar](20) NULL,
	[dt_nascimento] [datetime] NULL,
	[cd_sexo] [bit] NULL,
	[dt_contrato] [datetime] NULL,
	[cd_situacao] [smallint] NULL,
	[dt_situacao] [datetime] NULL,
	[nm_titular_cta] [varchar](50) NULL,
	[cd_banco] [int] NULL,
	[nr_agencia] [varchar](20) NULL,
	[nr_conta] [varchar](20) NULL,
	[senha] [varchar](50) NULL,
	[nm_digital] [ntext] NULL,
	[bate_ponto] [int] NULL,
	[cd_faixa] [int] NULL,
	[Dia_Corte] [int] NULL,
	[Sequencial_Conta] [int] NULL,
	[sequencial_conta_interno] [int] NULL,
	[QT_BaixaProcedInterno] [int] NOT NULL,
	[QT_BaixaProcedCredenciado] [int] NOT NULL,
	[fl_permitemarcacao] [smallint] NULL,
	[observacao] [varchar](500) NULL,
	[cd_clinicapadrao] [int] NULL,
	[ramal] [varchar](11) NULL,
	[fl_bateponto] [bit] NULL,
	[gfuId] [int] NULL,
	[vl_cm_dentista_exec] [money] NULL,
	[vl_cm_dentista_avali] [money] NULL,
	[fl_exibir_vl_cm_produt] [bit] NULL,
	[nr_inss] [varchar](20) NULL,
	[cd_centro_custo] [smallint] NULL,
	[fl_foto] [bit] NULL,
	[vl_cm_dentista_orto] [money] NULL,
	[nr_cnpj] [varchar](14) NULL,
	[pontuacao_dentista] [tinyint] NULL,
	[nr_contrato] [varchar](14) NULL,
	[QtLimiteBaixaEmPaciente] [tinyint] NULL,
	[cd_situacao_entradaContrato] [smallint] NULL,
	[dt_descredenciamento] [datetime] NULL,
	[CodExternoImportacao] [int] NULL,
	[cd_tab_comissao] [int] NULL,
	[dt_cadastro] [datetime] NULL,
	[cod_easy] [int] NULL,
	[fl_baixaadesao_automatico] [int] NULL,
	[nm_reduzido] [varchar](30) NULL,
	[fl_rateio_produt] [bit] NULL,
	[dt_alteracao_senha] [datetime] NULL,
	[executarTrigger] [bit] NULL,
	[ufId_cro] [smallint] NULL,
	[geraComissao] [bit] NULL,
	[exigeMeta] [bit] NULL,
	[percComissao] [money] NULL,
	[perfilVendedor] [tinyint] NULL,
	[gerarGratificacaoClinicoPeriodo] [bit] NULL,
	[conta_operacao] [int] NULL,
	[metaNovosPacientes] [int] NULL,
	[geraComissaoOrto] [bit] NULL,
	[exigeMetaOrto] [bit] NULL,
	[percComissaoOrto] [money] NULL,
	[perfilVendedorOrto] [tinyint] NULL,
	[gerarGratificacaoOrtoPeriodo] [bit] NULL,
	[idModelo] [int] NULL,
	[percTaxaCredito] [money] NULL,
	[percTaxaDebito] [money] NULL,
	[tipoDeducao] [tinyint] NULL,
	[deducao] [money] NULL,
	[cd_contabilidade] [int] NULL,
	[cd_tabela_contabilidade] [int] NULL,
	[operadorCallCenter] [varchar](50) NULL,
	[vl_descontoAdesaoProlabore] [money] NULL,
	[dt_limiteDescontoAdesaoProlabore] [datetime] NULL,
	[numeroTitulo] [varchar](20) NULL,
	[numeroZora] [int] NULL,
	[numeroSecao] [int] NULL,
	[cd_municipioTitulo] [int] NULL,
	[ufIdTitulo] [int] NULL,
	[cidadeNaturalidade] [int] NULL,
	[ufNaturalidade] [smallint] NULL,
	[geraComissaoOrtoAdesao] [bit] NULL,
	[percComissaoOrtoAdesao] [money] NULL,
	[exigeMetaOrtoAdesao] [bit] NULL,
	[perfilVendedorOrtoAdesao] [tinyint] NULL,
	[arquivoExportacao] [int] NULL,
	[gerarGratificacaoOrtoAdesaoPeriodo] [bit] NULL,
	[idCBOS] [int] NULL,
	[cd_caixafinanceira] [int] NULL,
	[qtdePesoProcedimentoProdutividade] [smallint] NULL,
	[enderecoCarteira] [bit] NULL,
	[croDataExpedicao] [date] NULL,
	[iss] [varchar](8) NULL,
	[pontoDeReferencia] [varchar](200) NULL,
	[nit_pis] [varchar](11) NULL,
	[Sequencial_ContaVitalicio] [int] NULL,
	[forma_pagamento_comissao] [smallint] NULL,
	[estadoCivil] [tinyint] NULL,
	[token] [uniqueidentifier] NULL,
	[periciaFinal] [bit] NULL,
	[Usuario_limite_padrao] [int] NULL,
	[nis] [varchar](11) NULL,
	[useBancoArquivos] [bit] NULL,
	[loginAlternativo] [varchar](50) NULL,
	[DbCPF] [varchar](11) NULL,
	[DbCNPJ] [varchar](14) NULL,
	[flanalisaProcedimentoPag] [bit] NULL,
	[exigirDocumentacaoProcedimento] [tinyint] NULL,
	[chavepix] [varchar](50) NULL,
 CONSTRAINT [PK_FUNCIONARIO] PRIMARY KEY NONCLUSTERED 
(
	[cd_funcionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 20, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE CLUSTERED INDEX [_dta_index_FUNCIONARIO_c_10_1428616578] ON [dbo].[FUNCIONARIO]
(
	[cd_funcionario] ASC,
	[cd_tabela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_FUNCIONARIO_10_1428616578] ON [dbo].[FUNCIONARIO]
(
	[cd_funcionario] ASC
)
INCLUDE([cd_tabela]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_FUNCIONARIO_5_1486484920__K21_K16_K1_K2] ON [dbo].[FUNCIONARIO]
(
	[cd_situacao] ASC,
	[cd_equipe] ASC,
	[cd_funcionario] ASC,
	[nm_empregado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_FUNCIONARIO_8_829662449__K1_K21_K2] ON [dbo].[FUNCIONARIO]
(
	[cd_funcionario] ASC,
	[cd_situacao] ASC,
	[nm_empregado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_FUNCIONARIO_8_829662449__K21_K1] ON [dbo].[FUNCIONARIO]
(
	[cd_situacao] ASC,
	[cd_funcionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_FUNCIONARIO_8_829662449__K21_K1_K2] ON [dbo].[FUNCIONARIO]
(
	[cd_situacao] ASC,
	[cd_funcionario] ASC,
	[nm_empregado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_FUNCIONARIO_9_1428616578] ON [dbo].[FUNCIONARIO]
(
	[cd_funcionario] ASC,
	[nm_empregado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_FUNCIONARIO] ON [dbo].[FUNCIONARIO]
(
	[nm_empregado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 20, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_FUNCIONARIO_1] ON [dbo].[FUNCIONARIO]
(
	[BaiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_FUNCIONARIO_2] ON [dbo].[FUNCIONARIO]
(
	[cd_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_FUNCIONARIO_3] ON [dbo].[FUNCIONARIO]
(
	[cd_cargo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_FUNCIONARIO_4] ON [dbo].[FUNCIONARIO]
(
	[cd_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_FUNCIONARIO_5] ON [dbo].[FUNCIONARIO]
(
	[CidID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_FUNCIONARIO_6] ON [dbo].[FUNCIONARIO]
(
	[cro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_FUNCIONARIO_7] ON [dbo].[FUNCIONARIO]
(
	[nr_cpf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_FUNCIONARIO_8] ON [dbo].[FUNCIONARIO]
(
	[ufId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Funcionario_Banco] ON [dbo].[FUNCIONARIO]
(
	[cd_banco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[FUNCIONARIO] ADD  CONSTRAINT [DF_FUNCIONARIO_QT_BaixaProcedimentoInterno]  DEFAULT ((1)) FOR [QT_BaixaProcedInterno]
ALTER TABLE [dbo].[FUNCIONARIO] ADD  CONSTRAINT [DF_FUNCIONARIO_QT_BaixaProcedimentoCredenciado]  DEFAULT ((1)) FOR [QT_BaixaProcedCredenciado]
ALTER TABLE [dbo].[FUNCIONARIO]  WITH CHECK ADD  CONSTRAINT [FK__FUNCIONAR__cd_co__36FD037E] FOREIGN KEY([cd_contabilidade])
REFERENCES [dbo].[Contabilidade] ([cd_contabilidade])
ALTER TABLE [dbo].[FUNCIONARIO] CHECK CONSTRAINT [FK__FUNCIONAR__cd_co__36FD037E]
ALTER TABLE [dbo].[FUNCIONARIO]  WITH CHECK ADD  CONSTRAINT [FK__FUNCIONAR__cd_ta__37F127B7] FOREIGN KEY([cd_tabela_contabilidade])
REFERENCES [dbo].[tabela_contabilidade] ([cd_tabela_contabilidade])
ALTER TABLE [dbo].[FUNCIONARIO] CHECK CONSTRAINT [FK__FUNCIONAR__cd_ta__37F127B7]
ALTER TABLE [dbo].[FUNCIONARIO]  WITH CHECK ADD  CONSTRAINT [FK_cd_tab_comissao] FOREIGN KEY([cd_tab_comissao])
REFERENCES [dbo].[Tabelas_Comissao] ([cd_tabela_comissao])
ALTER TABLE [dbo].[FUNCIONARIO] CHECK CONSTRAINT [FK_cd_tab_comissao]
ALTER TABLE [dbo].[FUNCIONARIO]  WITH CHECK ADD  CONSTRAINT [FK_Cidade_Naturalidade] FOREIGN KEY([cidadeNaturalidade])
REFERENCES [dbo].[MUNICIPIO] ([CD_MUNICIPIO])
ALTER TABLE [dbo].[FUNCIONARIO] CHECK CONSTRAINT [FK_Cidade_Naturalidade]
ALTER TABLE [dbo].[FUNCIONARIO]  WITH CHECK ADD  CONSTRAINT [FK_FUNCIONARIO_CBOS] FOREIGN KEY([idCBOS])
REFERENCES [dbo].[CBOS] ([id])
ALTER TABLE [dbo].[FUNCIONARIO] CHECK CONSTRAINT [FK_FUNCIONARIO_CBOS]
ALTER TABLE [dbo].[FUNCIONARIO]  WITH CHECK ADD  CONSTRAINT [FK_Funcionario_ModeloPagamentoCartaoDentista] FOREIGN KEY([idModelo])
REFERENCES [dbo].[ModeloPagamentoCartaoDentista] ([idModelo])
ALTER TABLE [dbo].[FUNCIONARIO] CHECK CONSTRAINT [FK_Funcionario_ModeloPagamentoCartaoDentista]
ALTER TABLE [dbo].[FUNCIONARIO]  WITH NOCHECK ADD  CONSTRAINT [FK_FUNCIONARIO_Tabela] FOREIGN KEY([cd_tabela])
REFERENCES [dbo].[Tabela] ([cd_tabela])
ALTER TABLE [dbo].[FUNCIONARIO] CHECK CONSTRAINT [FK_FUNCIONARIO_Tabela]
ALTER TABLE [dbo].[FUNCIONARIO]  WITH CHECK ADD  CONSTRAINT [FK_UF_Naturalidade] FOREIGN KEY([ufNaturalidade])
REFERENCES [dbo].[UF] ([ufId])
ALTER TABLE [dbo].[FUNCIONARIO] CHECK CONSTRAINT [FK_UF_Naturalidade]
ALTER TABLE [dbo].[FUNCIONARIO]  WITH CHECK ADD  CONSTRAINT [fk_ufId_cro_func] FOREIGN KEY([ufId_cro])
REFERENCES [dbo].[UF] ([ufId])
ALTER TABLE [dbo].[FUNCIONARIO] CHECK CONSTRAINT [fk_ufId_cro_func]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Funcionario|&' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'nm_empregado'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tabela|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'cd_tabela'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cep' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'LogCep'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'CHAVE_TIPOLOGRADOURO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Endereço' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'EndLogradouro'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Número' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'EndNumero'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Complemento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'EndComplemento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bairro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'BaiId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cidade' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'CidID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'UF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'ufId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CPF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'nr_cpf'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'RG' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'nr_identidade'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Orgão Expedidor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'nm_orgaoexp'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cargo|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'cd_cargo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Equipe' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'cd_equipe'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'cro'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Nascimento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'dt_nascimento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sexo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'cd_sexo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Contrato' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'dt_contrato'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Situação|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'cd_situacao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Situação' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'dt_situacao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nome Titular Conta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'nm_titular_cta'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Banco' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'cd_banco'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agencia' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'nr_agencia'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Conta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'nr_conta'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'senha'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'nm_digital'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'bate_ponto'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Faixa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'cd_faixa'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Grupo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'Dia_Corte'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sequencial Conta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'Sequencial_Conta'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sequencial Conta Interno' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'sequencial_conta_interno'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Qt Baixa Procedimento Int' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'QT_BaixaProcedInterno'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Qt  Baixa Procedimento Cred' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'QT_BaixaProcedCredenciado'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Permite Marcação' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'fl_permitemarcacao'
EXEC sys.sp_addextendedproperty @name=N'descricao_funcionario_arquivoExportacao', @value=N'NULL/1 - Padrão S4E; Outros - padrão definido pelo cliente; ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FUNCIONARIO', @level2type=N'COLUMN',@level2name=N'arquivoExportacao'
