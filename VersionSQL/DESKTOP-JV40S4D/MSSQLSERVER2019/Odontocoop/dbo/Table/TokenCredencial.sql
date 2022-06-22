/****** Object:  Table [dbo].[TokenCredencial]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TokenCredencial](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[login] [uniqueidentifier] NOT NULL,
	[senha] [varchar](50) NOT NULL,
	[descricao] [varchar](500) NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[ativo] [bit] NOT NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
	[usuarioFacial] [varchar](50) NULL,
	[chaveFacial] [varchar](50) NULL,
 CONSTRAINT [PK_TokenCredencial] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [IX_TokenCredencial] ON [dbo].[TokenCredencial]
(
	[login] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TokenCredencial]  WITH CHECK ADD  CONSTRAINT [FK_TokenCredencial_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[TokenCredencial] CHECK CONSTRAINT [FK_TokenCredencial_FUNCIONARIO]
ALTER TABLE [dbo].[TokenCredencial]  WITH CHECK ADD  CONSTRAINT [FK_TokenCredencial_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[TokenCredencial] CHECK CONSTRAINT [FK_TokenCredencial_FUNCIONARIO1]
