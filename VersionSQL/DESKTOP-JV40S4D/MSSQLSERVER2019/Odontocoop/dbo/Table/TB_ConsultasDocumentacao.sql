/****** Object:  Table [dbo].[TB_ConsultasDocumentacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ConsultasDocumentacao](
	[Sequencial_ConsultasDocumentacao] [int] IDENTITY(1,1) NOT NULL,
	[foto_digitalizada] [smallint] NULL,
	[cd_sequencial] [int] NULL,
	[ds_motivo] [varchar](200) NULL,
 CONSTRAINT [PK_TB_DocumentcaoConsulta] PRIMARY KEY CLUSTERED 
(
	[Sequencial_ConsultasDocumentacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_TB_ConsultasDocumentacao_9_1287883855] ON [dbo].[TB_ConsultasDocumentacao]
(
	[cd_sequencial] ASC,
	[Sequencial_ConsultasDocumentacao] ASC
)
INCLUDE([foto_digitalizada],[ds_motivo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TB_ConsultasDocumentacao]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_ConsultasDocumentacao_Consultas] FOREIGN KEY([cd_sequencial])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[TB_ConsultasDocumentacao] CHECK CONSTRAINT [FK_TB_ConsultasDocumentacao_Consultas]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 - Pendente , 2 - Documentacao Aceita' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_ConsultasDocumentacao', @level2type=N'COLUMN',@level2name=N'foto_digitalizada'
