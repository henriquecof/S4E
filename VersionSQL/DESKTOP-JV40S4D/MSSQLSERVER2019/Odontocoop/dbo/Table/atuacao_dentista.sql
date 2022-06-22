/****** Object:  Table [dbo].[atuacao_dentista]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[atuacao_dentista](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[CD_filial] [int] NOT NULL,
	[CD_FUNCIONARIO] [int] NOT NULL,
	[cd_especialidade] [int] NULL,
	[qt_tempo_atend] [int] NOT NULL,
	[HI] [datetime] NOT NULL,
	[HF] [datetime] NOT NULL,
	[dt_inicio] [smalldatetime] NOT NULL,
	[dt_fim] [smalldatetime] NULL,
	[fl_ativo] [bit] NOT NULL,
	[valor_ajuda_custo] [money] NULL,
	[dia_semana_1] [smallint] NOT NULL,
	[dia_semana_2] [smallint] NOT NULL,
	[dia_semana_3] [smallint] NOT NULL,
	[dia_semana_4] [smallint] NOT NULL,
	[dia_semana_5] [smallint] NOT NULL,
	[dia_semana_6] [smallint] NOT NULL,
	[dia_semana_7] [smallint] NOT NULL,
	[qt_encaixe] [smallint] NULL,
	[qt_tempo_atend_encaixe] [smallint] NULL,
	[fl_permite_marcacao] [bit] NULL,
	[fl_divulgar_rede_atendimento] [bit] NULL,
	[dt_cadastro] [datetime] NULL,
	[cd_funcionario_cadastro] [int] NULL,
	[atuacaoIdadeMinima] [int] NULL,
	[atuacaoIdadeMaxima] [int] NULL,
	[acessoPrestador] [bit] NULL,
 CONSTRAINT [PK_atuacao_dentista_new] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_atuacao_dentista_67_861610508__K1_K4] ON [dbo].[atuacao_dentista]
(
	[cd_sequencial] ASC,
	[cd_especialidade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_atuacao_dentista_new_2] ON [dbo].[atuacao_dentista]
(
	[CD_FUNCIONARIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[atuacao_dentista] ADD  CONSTRAINT [DF_atuacao_dentista_new_fl_ativo]  DEFAULT ((1)) FOR [fl_ativo]
ALTER TABLE [dbo].[atuacao_dentista]  WITH NOCHECK ADD  CONSTRAINT [FK_atuacao_dentista_FILIAL] FOREIGN KEY([CD_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[atuacao_dentista] CHECK CONSTRAINT [FK_atuacao_dentista_FILIAL]
ALTER TABLE [dbo].[atuacao_dentista]  WITH NOCHECK ADD  CONSTRAINT [FK_atuacao_dentista_FUNCIONARIO] FOREIGN KEY([CD_FUNCIONARIO], [cd_especialidade])
REFERENCES [dbo].[FUNCIONARIO_ESPECIALIDADE] ([CD_FUNCIONARIO], [CD_ESPECIALIDADE])
ON UPDATE CASCADE
ALTER TABLE [dbo].[atuacao_dentista] CHECK CONSTRAINT [FK_atuacao_dentista_FUNCIONARIO]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Filial|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'atuacao_dentista', @level2type=N'COLUMN',@level2name=N'CD_filial'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Funcionario|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'atuacao_dentista', @level2type=N'COLUMN',@level2name=N'CD_FUNCIONARIO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Especialidade|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'atuacao_dentista', @level2type=N'COLUMN',@level2name=N'cd_especialidade'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tempo Atendimento|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'atuacao_dentista', @level2type=N'COLUMN',@level2name=N'qt_tempo_atend'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Hora Ini.|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'atuacao_dentista', @level2type=N'COLUMN',@level2name=N'HI'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Hora Fin.|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'atuacao_dentista', @level2type=N'COLUMN',@level2name=N'HF'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor Custo|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'atuacao_dentista', @level2type=N'COLUMN',@level2name=N'valor_ajuda_custo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dia' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'atuacao_dentista', @level2type=N'COLUMN',@level2name=N'dia_semana_1'
