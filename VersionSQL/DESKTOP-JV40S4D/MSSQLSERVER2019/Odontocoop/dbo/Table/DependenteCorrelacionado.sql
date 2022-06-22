/****** Object:  Table [dbo].[DependenteCorrelacionado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DependenteCorrelacionado](
	[dcoId] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial1] [int] NOT NULL,
	[cd_sequencial2] [int] NOT NULL,
 CONSTRAINT [PK_DependenteCorrelacionado] PRIMARY KEY CLUSTERED 
(
	[dcoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_DependenteCorrelacionado_cd_sequencial_1] ON [dbo].[DependenteCorrelacionado]
(
	[cd_sequencial1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_DependenteCorrelacionado_cd_sequencial_2] ON [dbo].[DependenteCorrelacionado]
(
	[cd_sequencial2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[DependenteCorrelacionado]  WITH CHECK ADD  CONSTRAINT [FK_DependenteCorrelacionado_DEPENDENTES] FOREIGN KEY([cd_sequencial1])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[DependenteCorrelacionado] CHECK CONSTRAINT [FK_DependenteCorrelacionado_DEPENDENTES]
ALTER TABLE [dbo].[DependenteCorrelacionado]  WITH CHECK ADD  CONSTRAINT [FK_DependenteCorrelacionado_DEPENDENTES1] FOREIGN KEY([cd_sequencial2])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[DependenteCorrelacionado] CHECK CONSTRAINT [FK_DependenteCorrelacionado_DEPENDENTES1]
