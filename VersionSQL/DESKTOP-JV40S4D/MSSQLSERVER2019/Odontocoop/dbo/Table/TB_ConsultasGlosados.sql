/****** Object:  Table [dbo].[TB_ConsultasGlosados]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ConsultasGlosados](
	[Sequencial_ConsultasGlosados] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial] [int] NOT NULL,
	[Descricao_Glosa] [varchar](max) NULL,
	[codigo_antigo_servico] [int] NULL,
	[descricao_antigo_servico] [varchar](100) NULL,
	[tipo] [smallint] NOT NULL,
	[mglId] [int] NOT NULL,
	[mgrId] [int] NULL,
	[MotivoLiberacaoRecurso] [varchar](250) NULL,
	[cd_funcionarioLiberacaoRecurso] [int] NULL,
	[dtLiberacaoRecurso] [datetime] NULL,
	[cd_sequencialConsultaCriadoRecurso] [int] NULL,
	[DataCadastroGlosa] [datetime] NULL,
	[idMotivoGlosaDetalhado] [int] NULL,
	[tipoEntradaGlosa] [tinyint] NULL,
 CONSTRAINT [PK_TB_ServicosGlosados] PRIMARY KEY CLUSTERED 
(
	[Sequencial_ConsultasGlosados] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_TB_ConsultasGlosados_9_1239883684] ON [dbo].[TB_ConsultasGlosados]
(
	[cd_sequencial] ASC,
	[Sequencial_ConsultasGlosados] ASC,
	[mglId] ASC,
	[codigo_antigo_servico] ASC
)
INCLUDE([Descricao_Glosa],[tipo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_cd_sequencialConsultaCriadoRecurso] ON [dbo].[TB_ConsultasGlosados]
(
	[cd_sequencialConsultaCriadoRecurso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE UNIQUE NONCLUSTERED INDEX [IX_TB_ConsultasGlosados] ON [dbo].[TB_ConsultasGlosados]
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_ConsultasGlosados_1] ON [dbo].[TB_ConsultasGlosados]
(
	[codigo_antigo_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TB_ConsultasGlosados]  WITH CHECK ADD  CONSTRAINT [FK_TB_ConsultasGlosados_ConsultaCriadoRecurso] FOREIGN KEY([cd_sequencialConsultaCriadoRecurso])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[TB_ConsultasGlosados] CHECK CONSTRAINT [FK_TB_ConsultasGlosados_ConsultaCriadoRecurso]
ALTER TABLE [dbo].[TB_ConsultasGlosados]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_ConsultasGlosados_Consultas] FOREIGN KEY([cd_sequencial])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[TB_ConsultasGlosados] CHECK CONSTRAINT [FK_TB_ConsultasGlosados_Consultas]
ALTER TABLE [dbo].[TB_ConsultasGlosados]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_ConsultasGlosados_MotivoGlosa] FOREIGN KEY([mglId])
REFERENCES [dbo].[MotivoGlosa] ([mglId])
ALTER TABLE [dbo].[TB_ConsultasGlosados] CHECK CONSTRAINT [FK_TB_ConsultasGlosados_MotivoGlosa]
ALTER TABLE [dbo].[TB_ConsultasGlosados]  WITH CHECK ADD  CONSTRAINT [FK_TB_ConsultasGlosados_MotivoGlosaRecurso] FOREIGN KEY([mgrId])
REFERENCES [dbo].[MotivoGlosaRecurso] ([mgrId])
ALTER TABLE [dbo].[TB_ConsultasGlosados] CHECK CONSTRAINT [FK_TB_ConsultasGlosados_MotivoGlosaRecurso]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1-Glosa Parcial, 2-Glosa Total' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_ConsultasGlosados', @level2type=N'COLUMN',@level2name=N'tipo'
