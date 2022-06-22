/****** Object:  Table [dbo].[ArquivoConsultas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ArquivoConsultas](
	[arcId] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial] [int] NULL,
	[arcUsuExclusao] [int] NULL,
	[arcDtExclusao] [datetime] NULL,
	[arcNome] [varchar](100) NOT NULL,
	[arcExtensao] [varchar](5) NOT NULL,
	[arcUsuInclusao] [int] NULL,
	[arcDtInclusao] [datetime] NULL,
	[cd_sequencial_dep] [int] NULL,
	[arcDescricao] [varchar](500) NULL,
	[nr_gto] [varchar](50) NULL,
	[idTipoArquivo] [tinyint] NULL,
	[idConsultaTemp] [int] NULL,
	[arcDtVisualizacao] [datetime] NULL,
	[cd_funcionarioVisualizacao] [int] NULL,
 CONSTRAINT [PK_ArquivoConsulta] PRIMARY KEY CLUSTERED 
(
	[arcId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_ArquivoConsultas] ON [dbo].[ArquivoConsultas]
(
	[nr_gto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ArquivoConsultas_1] ON [dbo].[ArquivoConsultas]
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ArquivoConsultas_2] ON [dbo].[ArquivoConsultas]
(
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[ArquivoConsultas]  WITH NOCHECK ADD  CONSTRAINT [FK_ArquivoConsulta_Consultas] FOREIGN KEY([cd_sequencial])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[ArquivoConsultas] CHECK CONSTRAINT [FK_ArquivoConsulta_Consultas]
ALTER TABLE [dbo].[ArquivoConsultas]  WITH CHECK ADD  CONSTRAINT [FK_ArquivoConsultas_FUNCIONARIO_Exclusao] FOREIGN KEY([arcUsuExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ArquivoConsultas] CHECK CONSTRAINT [FK_ArquivoConsultas_FUNCIONARIO_Exclusao]
ALTER TABLE [dbo].[ArquivoConsultas]  WITH CHECK ADD  CONSTRAINT [FK_ArquivoConsultas_FUNCIONARIO_Inclusao] FOREIGN KEY([arcUsuInclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ArquivoConsultas] CHECK CONSTRAINT [FK_ArquivoConsultas_FUNCIONARIO_Inclusao]
