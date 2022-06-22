/****** Object:  Table [dbo].[Servico_Correlacionado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Servico_Correlacionado](
	[id_servico] [int] IDENTITY(1,1) NOT NULL,
	[CD_SERVICO] [int] NOT NULL,
	[cd_servico_aux] [int] NOT NULL,
	[vl_servico_orcamento] [money] NULL,
	[oclusal] [bit] NULL,
	[distal] [bit] NULL,
	[mesial] [bit] NULL,
	[vestibular] [bit] NULL,
	[lingual] [bit] NULL,
	[rboId] [tinyint] NULL,
 CONSTRAINT [PK_Servico_Correlacionado] PRIMARY KEY CLUSTERED 
(
	[id_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Servico_Correlacionado]  WITH NOCHECK ADD  CONSTRAINT [FK_Servico_Correlacionado_SERVICO] FOREIGN KEY([CD_SERVICO])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[Servico_Correlacionado] CHECK CONSTRAINT [FK_Servico_Correlacionado_SERVICO]
ALTER TABLE [dbo].[Servico_Correlacionado]  WITH NOCHECK ADD  CONSTRAINT [FK_Servico_Correlacionado_SERVICO1] FOREIGN KEY([cd_servico_aux])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[Servico_Correlacionado] CHECK CONSTRAINT [FK_Servico_Correlacionado_SERVICO1]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Código' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Servico_Correlacionado', @level2type=N'COLUMN',@level2name=N'CD_SERVICO'
