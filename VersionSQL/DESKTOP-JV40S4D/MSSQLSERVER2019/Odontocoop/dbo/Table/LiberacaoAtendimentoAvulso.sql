/****** Object:  Table [dbo].[LiberacaoAtendimentoAvulso]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LiberacaoAtendimentoAvulso](
	[laaId] [int] IDENTITY(1,1) NOT NULL,
	[laaDataAtendimento] [datetime] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_filial] [int] NULL,
	[cd_funcionarioDentista] [int] NULL,
	[cd_funcionarioLiberacao] [int] NOT NULL,
	[laaDataLiberacao] [datetime] NOT NULL,
	[laaUtilizado] [bigint] NOT NULL,
	[laaObservacao] [varchar](500) NULL,
	[laaTipoLiberacaoData] [smallint] NULL,
 CONSTRAINT [PK_LiberacaoAtendimentoAvulso] PRIMARY KEY CLUSTERED 
(
	[laaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LiberacaoAtendimentoAvulso]  WITH CHECK ADD  CONSTRAINT [FK_LiberacaoAtendimentoAvulso_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[LiberacaoAtendimentoAvulso] CHECK CONSTRAINT [FK_LiberacaoAtendimentoAvulso_DEPENDENTES]
ALTER TABLE [dbo].[LiberacaoAtendimentoAvulso]  WITH CHECK ADD  CONSTRAINT [FK_LiberacaoAtendimentoAvulso_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[LiberacaoAtendimentoAvulso] CHECK CONSTRAINT [FK_LiberacaoAtendimentoAvulso_FILIAL]
