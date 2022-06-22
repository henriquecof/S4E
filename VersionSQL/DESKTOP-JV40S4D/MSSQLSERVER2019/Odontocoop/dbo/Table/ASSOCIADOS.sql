/****** Object:  Table [dbo].[ASSOCIADOS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ASSOCIADOS](
	[cd_associado] [int] IDENTITY(1,1) NOT NULL,
	[nm_completo] [varchar](100) NULL,
	[cd_empresa] [int] NOT NULL,
	[dt_nascimento] [datetime] NULL,
	[nr_cpf] [varchar](11) NULL,
	[nr_identidade] [varchar](20) NULL,
	[nm_orgaoexp] [varchar](10) NULL,
	[nr_contrato] [int] NULL,
	[dt_assinatura_contrato] [datetime] NOT NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[dt_atualizacao] [datetime] NOT NULL,
	[LogCep] [varchar](8) NULL,
	[CHAVE_TIPOLOGRADOURO] [int] NULL,
	[EndLogradouro] [varchar](100) NULL,
	[EndNumero] [int] NULL,
	[EndComplemento] [varchar](100) NULL,
	[BaiId] [int] NULL,
	[CidID] [int] NULL,
	[ufId] [smallint] NULL,
	[fl_vip] [smallint] NULL,
	[nu_matricula] [varchar](30) NULL,
	[sg_lotacao] [varchar](10) NULL,
	[nr_folha] [varchar](10) NULL,
	[Agencia] [int] NULL,
	[Agencia_DV] [varchar](1) NULL,
	[nr_conta] [varchar](20) NULL,
	[nr_conta_DV] [varchar](1) NULL,
	[nr_autorizacao] [varchar](50) NULL,
	[val_cartao] [varchar](6) NULL,
	[cd_seguranca] [varchar](4) NULL,
	[senha] [varchar](50) NULL,
	[coment_carteira] [varchar](60) NULL,
	[cd_empresa_origem] [int] NULL,
	[cd_uf_2] [char](2) NULL,
	[dt_atualizacao_email] [datetime] NULL,
	[nr_periodicidade] [smallint] NULL,
	[nr_parcelas] [smallint] NULL,
	[nr_conta_operacao] [smallint] NULL,
	[cd_ass] [int] NULL,
	[fl_sexo] [bit] NULL,
	[dt_apresentacao] [datetime] NULL,
	[dt_cobranca] [datetime] NULL,
	[cd_bandeira] [smallint] NULL,
	[tmiId] [tinyint] NULL,
	[taxa_cobranca] [bit] NULL,
	[fl_captura_URA] [bit] NULL,
	[depId] [smallint] NULL,
	[cta_ope] [varchar](4) NULL,
	[nr_seguro] [varchar](50) NULL,
	[fl_emite_NF] [bit] NULL,
	[fl_boletoAnual] [bit] NULL,
	[cd_centro_custo] [smallint] NULL,
	[dt_alteracao_senha] [datetime] NULL,
	[EmpresaAnterior] [varchar](200) NULL,
	[CargoOcupado] [int] NULL,
	[EmpresaContato] [varchar](20) NULL,
	[executarTrigger] [bit] NULL,
	[endBoleto] [varchar](40) NULL,
	[chaveExportacao] [varchar](50) NULL,
	[nomeImpressoCartao] [varchar](200) NULL,
	[pontoDeReferencia] [varchar](200) NULL,
	[dia_vencimento_cartao] [tinyint] NULL,
	[nm_mae] [varchar](244) NULL,
	[nm_pai] [varchar](244) NULL,
	[dia_vencimento] [tinyint] NULL,
	[enviaParcelaLoteEnvio] [bit] NULL,
	[cd_tipo_pagamento] [int] NULL,
	[aceiteContrato] [bit] NULL,
	[impressaoBoletoLote] [int] NULL,
	[chave] [varchar](50) NULL,
	[id_convenio] [int] NULL,
	[NumeroUsuario] [int] NULL,
	[Naturalidade] [int] NULL,
	[Observacao] [varchar](200) NULL,
	[cd_banco] [int] NULL,
	[dtAdmissao] [date] NULL,
	[dtCasamento] [date] NULL,
	[EnvioGrafica] [bit] NULL,
	[estadoCivil] [tinyint] NULL,
	[alias_interno] [varchar](50) NULL,
	[tokenCartao] [varchar](50) NULL,
 CONSTRAINT [PK_ASSOCIADOS] PRIMARY KEY NONCLUSTERED 
(
	[cd_associado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE CLUSTERED INDEX [_dta_index_ASSOCIADOS_c_6_739338244__K3_K1] ON [dbo].[ASSOCIADOS]
(
	[cd_empresa] ASC,
	[cd_associado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_ASSOCIADOS_5_1048351495__K3_K1] ON [dbo].[ASSOCIADOS]
(
	[cd_empresa] ASC,
	[cd_associado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [ID_Associado] ON [dbo].[ASSOCIADOS]
(
	[nr_autorizacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [ID_Associado_002] ON [dbo].[ASSOCIADOS]
(
	[nm_completo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ASSOCIADOS] ON [dbo].[ASSOCIADOS]
(
	[cd_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ASSOCIADOS_1] ON [dbo].[ASSOCIADOS]
(
	[dt_cobranca] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ASSOCIADOS_2] ON [dbo].[ASSOCIADOS]
(
	[BaiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ASSOCIADOS_3] ON [dbo].[ASSOCIADOS]
(
	[CidID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ASSOCIADOS_4] ON [dbo].[ASSOCIADOS]
(
	[dt_assinatura_contrato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_ASSOCIADOS_5] ON [dbo].[ASSOCIADOS]
(
	[nr_cpf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ASSOCIADOS_6] ON [dbo].[ASSOCIADOS]
(
	[ufId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ASSOCIADOS_7] ON [dbo].[ASSOCIADOS]
(
	[cd_ass] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ASSOCIADOS_8] ON [dbo].[ASSOCIADOS]
(
	[cd_associado] ASC,
	[cd_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ASSOCIADOS_9] ON [dbo].[ASSOCIADOS]
(
	[depId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[ASSOCIADOS]  WITH NOCHECK ADD  CONSTRAINT [FK_ASSOCIADOS_Bairro] FOREIGN KEY([BaiId])
REFERENCES [dbo].[Bairro] ([baiId])
ALTER TABLE [dbo].[ASSOCIADOS] CHECK CONSTRAINT [FK_ASSOCIADOS_Bairro]
ALTER TABLE [dbo].[ASSOCIADOS]  WITH NOCHECK ADD  CONSTRAINT [FK_ASSOCIADOS_Bandeira] FOREIGN KEY([cd_bandeira])
REFERENCES [dbo].[Bandeira] ([cd_bandeira])
ALTER TABLE [dbo].[ASSOCIADOS] CHECK CONSTRAINT [FK_ASSOCIADOS_Bandeira]
ALTER TABLE [dbo].[ASSOCIADOS]  WITH CHECK ADD  CONSTRAINT [FK_ASSOCIADOS_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[ASSOCIADOS] CHECK CONSTRAINT [FK_ASSOCIADOS_Centro_Custo]
ALTER TABLE [dbo].[ASSOCIADOS]  WITH CHECK ADD  CONSTRAINT [FK_Associados_Departamento] FOREIGN KEY([depId])
REFERENCES [dbo].[Departamento] ([depId])
ALTER TABLE [dbo].[ASSOCIADOS] CHECK CONSTRAINT [FK_Associados_Departamento]
ALTER TABLE [dbo].[ASSOCIADOS]  WITH NOCHECK ADD  CONSTRAINT [FK_ASSOCIADOS_MUNICIPIO] FOREIGN KEY([CidID])
REFERENCES [dbo].[MUNICIPIO] ([CD_MUNICIPIO])
ALTER TABLE [dbo].[ASSOCIADOS] CHECK CONSTRAINT [FK_ASSOCIADOS_MUNICIPIO]
ALTER TABLE [dbo].[ASSOCIADOS]  WITH CHECK ADD  CONSTRAINT [FK_ASSOCIADOS_MUNICIPIO1] FOREIGN KEY([Naturalidade])
REFERENCES [dbo].[MUNICIPIO] ([CD_MUNICIPIO])
ALTER TABLE [dbo].[ASSOCIADOS] CHECK CONSTRAINT [FK_ASSOCIADOS_MUNICIPIO1]
ALTER TABLE [dbo].[ASSOCIADOS]  WITH NOCHECK ADD  CONSTRAINT [FK_ASSOCIADOS_TB_TIPOLOGRADOURO] FOREIGN KEY([CHAVE_TIPOLOGRADOURO])
REFERENCES [dbo].[TB_TIPOLOGRADOURO] ([CHAVE_TIPOLOGRADOURO])
ALTER TABLE [dbo].[ASSOCIADOS] CHECK CONSTRAINT [FK_ASSOCIADOS_TB_TIPOLOGRADOURO]
ALTER TABLE [dbo].[ASSOCIADOS]  WITH NOCHECK ADD  CONSTRAINT [FK_ASSOCIADOS_TipoMidia] FOREIGN KEY([tmiId])
REFERENCES [dbo].[TipoMidia] ([tmiId])
ALTER TABLE [dbo].[ASSOCIADOS] CHECK CONSTRAINT [FK_ASSOCIADOS_TipoMidia]
ALTER TABLE [dbo].[ASSOCIADOS]  WITH NOCHECK ADD  CONSTRAINT [FK_ASSOCIADOS_TipoMidia1] FOREIGN KEY([tmiId])
REFERENCES [dbo].[TipoMidia] ([tmiId])
ALTER TABLE [dbo].[ASSOCIADOS] CHECK CONSTRAINT [FK_ASSOCIADOS_TipoMidia1]
ALTER TABLE [dbo].[ASSOCIADOS]  WITH NOCHECK ADD  CONSTRAINT [FK_ASSOCIADOS_TipoPagamento] FOREIGN KEY([cd_tipo_pagamento])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[ASSOCIADOS] CHECK CONSTRAINT [FK_ASSOCIADOS_TipoPagamento]
ALTER TABLE [dbo].[ASSOCIADOS]  WITH NOCHECK ADD  CONSTRAINT [FK_ASSOCIADOS_UF] FOREIGN KEY([ufId])
REFERENCES [dbo].[UF] ([ufId])
ALTER TABLE [dbo].[ASSOCIADOS] CHECK CONSTRAINT [FK_ASSOCIADOS_UF]
ALTER TABLE [dbo].[ASSOCIADOS]  WITH NOCHECK ADD  CONSTRAINT [FK_ASSOCIADOS_VIP] FOREIGN KEY([fl_vip])
REFERENCES [dbo].[VIP] ([fl_vip])
ALTER TABLE [dbo].[ASSOCIADOS] CHECK CONSTRAINT [FK_ASSOCIADOS_VIP]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nome|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'nm_completo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empresa|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'cd_empresa'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data de nascimento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'dt_nascimento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CPF|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'nr_cpf'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'RG' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'nr_identidade'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Orgão Expedidor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'nm_orgaoexp'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Número do Contrato|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'nr_contrato'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data de Assinatura' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'dt_assinatura_contrato'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Cadastro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'dt_cadastro'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Atualização' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'dt_atualizacao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CEP' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'LogCep'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'CHAVE_TIPOLOGRADOURO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Endereço' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'EndLogradouro'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Número' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'EndNumero'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Complemento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'EndComplemento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bairro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'BaiId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cidade' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'CidID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'UF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'ufId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Matrícula|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'nu_matricula'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agência' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'Agencia'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Conta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'nr_conta'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Número Autorização' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'nr_autorizacao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Validade Cartão' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'val_cartao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Código de Segurança' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'cd_seguranca'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empresa' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'cd_empresa_origem'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Atualização de Email' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'dt_atualizacao_email'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Periodicidade' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'nr_periodicidade'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parcelas' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'nr_parcelas'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Conta Operação' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ASSOCIADOS', @level2type=N'COLUMN',@level2name=N'nr_conta_operacao'
