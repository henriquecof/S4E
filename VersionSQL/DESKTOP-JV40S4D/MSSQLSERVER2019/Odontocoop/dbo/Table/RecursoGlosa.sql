/****** Object:  Table [dbo].[RecursoGlosa]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RecursoGlosa](
	[rglId] [int] IDENTITY(1,1) NOT NULL,
	[Sequencial_ConsultasGlosados] [int] NOT NULL,
	[rglDataCadastro] [datetime] NOT NULL,
	[rglJustificativaDentista] [varchar](500) NULL,
	[rglLiberado] [bit] NULL,
	[rglResposta] [varchar](500) NULL,
	[rglDataResposta] [datetime] NULL,
	[cd_funcionarioResposta] [int] NULL,
	[rglProtocolo] [varchar](20) NOT NULL,
	[rglDataCancelamento] [datetime] NULL,
	[cd_funcionarioCancelamento] [int] NULL,
	[mgrId] [int] NULL,
 CONSTRAINT [PK_RecursoGlosa] PRIMARY KEY CLUSTERED 
(
	[rglId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RecursoGlosa]  WITH CHECK ADD  CONSTRAINT [FK_RecursoGlosa_MotivoGlosaRecurso] FOREIGN KEY([mgrId])
REFERENCES [dbo].[MotivoGlosaRecurso] ([mgrId])
ALTER TABLE [dbo].[RecursoGlosa] CHECK CONSTRAINT [FK_RecursoGlosa_MotivoGlosaRecurso]
ALTER TABLE [dbo].[RecursoGlosa]  WITH CHECK ADD  CONSTRAINT [FK_RecursoGlosa_TB_ConsultasGlosados] FOREIGN KEY([Sequencial_ConsultasGlosados])
REFERENCES [dbo].[TB_ConsultasGlosados] ([Sequencial_ConsultasGlosados])
ALTER TABLE [dbo].[RecursoGlosa] CHECK CONSTRAINT [FK_RecursoGlosa_TB_ConsultasGlosados]
