/****** Object:  Table [dbo].[agenda]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[agenda](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[dt_compromisso] [smalldatetime] NOT NULL,
	[hr_compromisso] [smallint] NOT NULL,
	[cd_associado] [int] NULL,
	[cd_sequencial_dep] [int] NULL,
	[nm_anotacao] [varchar](60) NULL,
	[fl_primeira_vez] [tinyint] NULL,
	[dt_marcado] [datetime] NULL,
	[cd_usuario] [varchar](50) NULL,
	[hr_chegou] [int] NULL,
	[hr_entrou] [int] NULL,
	[cd_filial] [int] NULL,
	[debito] [varchar](50) NULL,
	[fl_baixa] [smallint] NULL,
	[nr_autorizacao] [varchar](30) NULL,
	[fl_urgencia] [tinyint] NULL,
	[fl_pendente_autorizacao] [bit] NULL,
	[nm_observacao] [varchar](1000) NULL,
	[cd_tipo_horario] [smallint] NULL,
	[cd_sequencial_atuacao_dent] [int] NULL,
	[nm_motivoatendimento] [varchar](300) NULL,
	[tp_usuario] [smallint] NULL,
	[fl_marcacao_avulsa] [bit] NULL,
	[fl_QuestionarioExame] [bit] NULL,
	[ChaveMarcacao] [varchar](50) NULL,
	[nm_observacao_Cobranca] [varchar](1000) NULL,
	[cd_especialidade] [int] NULL,
	[nm_protocolo_atendimento] [varchar](20) NULL,
	[fl_reserva] [bit] NULL,
	[fl_Confirmada] [bit] NULL,
	[fl_ortoDentistaDiferente] [bit] NULL,
	[Protocolo] [varchar](50) NULL,
	[hr_saiu] [int] NULL,
	[executarTrigger] [bit] NULL,
	[cd_dominioOrigemAcesso] [int] NULL,
	[hr_acaoComercial] [int] NULL,
	[MotivoReservaId] [int] NULL,
	[cd_sequencialAgendaPrincipal] [int] NULL,
 CONSTRAINT [PK_agenda001] PRIMARY KEY NONCLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE CLUSTERED INDEX [_dta_index_agenda_c_9_1471044722] ON [dbo].[agenda]
(
	[nm_anotacao] ASC,
	[cd_funcionario] ASC,
	[cd_filial] ASC,
	[dt_compromisso] ASC,
	[cd_associado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_agenda_67_1433472581__K1_K5_K3_K2_K13_K7_K4_K28_K6_K10_9_11_12_16_17_18_19_21_23_24_26_29] ON [dbo].[agenda]
(
	[cd_sequencial] ASC,
	[cd_associado] ASC,
	[dt_compromisso] ASC,
	[cd_funcionario] ASC,
	[cd_filial] ASC,
	[nm_anotacao] ASC,
	[hr_compromisso] ASC,
	[cd_especialidade] ASC,
	[cd_sequencial_dep] ASC,
	[cd_usuario] ASC
)
INCLUDE([dt_marcado],[hr_chegou],[hr_entrou],[nr_autorizacao],[fl_urgencia],[fl_pendente_autorizacao],[nm_observacao],[cd_sequencial_atuacao_dent],[tp_usuario],[fl_marcacao_avulsa],[ChaveMarcacao],[nm_protocolo_atendimento]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_agenda_67_1433472581__K6_K5_K4_K13_K3_K2_K7_K21_K1] ON [dbo].[agenda]
(
	[cd_sequencial_dep] ASC,
	[cd_associado] ASC,
	[hr_compromisso] ASC,
	[cd_filial] ASC,
	[dt_compromisso] ASC,
	[cd_funcionario] ASC,
	[nm_anotacao] ASC,
	[cd_sequencial_atuacao_dent] ASC,
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_agenda_8_1433472581__K5_K7_K2_K13_K3_K4_K21_K1] ON [dbo].[agenda]
(
	[cd_associado] ASC,
	[nm_anotacao] ASC,
	[cd_funcionario] ASC,
	[cd_filial] ASC,
	[dt_compromisso] ASC,
	[hr_compromisso] ASC,
	[cd_sequencial_atuacao_dent] ASC,
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_agenda_8_1433472581__K5_K7_K3_K4_K13_K2_K21_K1] ON [dbo].[agenda]
(
	[cd_associado] ASC,
	[nm_anotacao] ASC,
	[dt_compromisso] ASC,
	[hr_compromisso] ASC,
	[cd_filial] ASC,
	[cd_funcionario] ASC,
	[cd_sequencial_atuacao_dent] ASC,
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IDX_AgendaProtocolo] ON [dbo].[agenda]
(
	[Protocolo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_agenda] ON [dbo].[agenda]
(
	[hr_compromisso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_agenda_1] ON [dbo].[agenda]
(
	[cd_associado] ASC,
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_agenda_2] ON [dbo].[agenda]
(
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_agenda_3] ON [dbo].[agenda]
(
	[dt_compromisso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_agenda_4] ON [dbo].[agenda]
(
	[cd_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_agenda_5] ON [dbo].[agenda]
(
	[nm_anotacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_agenda_6] ON [dbo].[agenda]
(
	[ChaveMarcacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_agenda_7] ON [dbo].[agenda]
(
	[cd_funcionario] ASC,
	[cd_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_agenda_8] ON [dbo].[agenda]
(
	[cd_sequencialAgendaPrincipal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_agenda_9] ON [dbo].[agenda]
(
	[cd_sequencial_atuacao_dent] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[agenda] ADD  CONSTRAINT [DF_agenda_fl_pendente_autorizacao]  DEFAULT ((0)) FOR [fl_pendente_autorizacao]
ALTER TABLE [dbo].[agenda]  WITH NOCHECK ADD  CONSTRAINT [FK_agenda_ASSOCIADOS] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[agenda] CHECK CONSTRAINT [FK_agenda_ASSOCIADOS]
ALTER TABLE [dbo].[agenda]  WITH NOCHECK ADD  CONSTRAINT [FK_agenda_atuacao_dentista] FOREIGN KEY([cd_sequencial_atuacao_dent])
REFERENCES [dbo].[atuacao_dentista] ([cd_sequencial])
ALTER TABLE [dbo].[agenda] CHECK CONSTRAINT [FK_agenda_atuacao_dentista]
ALTER TABLE [dbo].[agenda]  WITH NOCHECK ADD  CONSTRAINT [FK_agenda_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[agenda] CHECK CONSTRAINT [FK_agenda_DEPENDENTES]
ALTER TABLE [dbo].[agenda]  WITH NOCHECK ADD  CONSTRAINT [FK_agenda_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[agenda] CHECK CONSTRAINT [FK_agenda_FILIAL]
ALTER TABLE [dbo].[agenda]  WITH CHECK ADD  CONSTRAINT [fk_MotivoReserva] FOREIGN KEY([MotivoReservaId])
REFERENCES [dbo].[MotivoReserva] ([Id])
ALTER TABLE [dbo].[agenda] CHECK CONSTRAINT [fk_MotivoReserva]
