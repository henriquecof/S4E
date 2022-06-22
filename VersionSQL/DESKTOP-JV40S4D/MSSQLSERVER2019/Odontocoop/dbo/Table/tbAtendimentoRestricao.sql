/****** Object:  Table [dbo].[tbAtendimentoRestricao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tbAtendimentoRestricao](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[araId] [tinyint] NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[arObservacao] [varchar](100) NULL,
 CONSTRAINT [PK_tbAtendimentoRestricao] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tbAtendimentoRestricao]  WITH NOCHECK ADD  CONSTRAINT [FK_tbAtendimentoRestricao_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[tbAtendimentoRestricao] CHECK CONSTRAINT [FK_tbAtendimentoRestricao_DEPENDENTES]
ALTER TABLE [dbo].[tbAtendimentoRestricao]  WITH NOCHECK ADD  CONSTRAINT [FK_tbAtendimentoRestricao_tbAtendimentoRestricaoAcao] FOREIGN KEY([araId])
REFERENCES [dbo].[tbAtendimentoRestricaoAcao] ([araID])
ALTER TABLE [dbo].[tbAtendimentoRestricao] CHECK CONSTRAINT [FK_tbAtendimentoRestricao_tbAtendimentoRestricaoAcao]
