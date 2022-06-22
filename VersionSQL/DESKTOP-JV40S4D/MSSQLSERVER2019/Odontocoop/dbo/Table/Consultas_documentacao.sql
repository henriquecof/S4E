/****** Object:  Table [dbo].[Consultas_documentacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Consultas_documentacao](
	[Sequencial_ConsultasDocumentacao] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial] [int] NOT NULL,
	[Foto_Digitalizada] [smallint] NULL,
	[Situacao] [smallint] NOT NULL,
	[Glosa] [varchar](500) NULL,
	[Tipo_Glosa] [smallint] NULL,
	[Glosa_Valida] [smallint] NULL,
	[Codigo_Novo_Servico] [int] NULL,
	[Codigo_Antigo_Servico] [int] NULL,
	[Valor_Antigo_Servico] [money] NULL,
	[Descricao_Antigo_Servico] [varchar](100) NULL,
 CONSTRAINT [PK_Consultas_documentacao] PRIMARY KEY CLUSTERED 
(
	[Sequencial_ConsultasDocumentacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Consultas_documentacao] ON [dbo].[Consultas_documentacao]
(
	[Codigo_Novo_Servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_documentacao_1] ON [dbo].[Consultas_documentacao]
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Consultas_documentacao]  WITH NOCHECK ADD  CONSTRAINT [FK_Consultas_documentacao_Consultas] FOREIGN KEY([cd_sequencial])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[Consultas_documentacao] CHECK CONSTRAINT [FK_Consultas_documentacao_Consultas]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 - Pendente
2 - Aceito
3 - Glosado' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Consultas_documentacao', @level2type=N'COLUMN',@level2name=N'Situacao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 - Troca de Procedimento
2 - Não Pagar Procedimento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Consultas_documentacao', @level2type=N'COLUMN',@level2name=N'Tipo_Glosa'
