/****** Object:  Table [dbo].[ServicoEspecialidade]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ServicoEspecialidade](
	[cd_servico] [int] NOT NULL,
	[cd_especialidade] [int] NOT NULL,
 CONSTRAINT [PK_ServicoEspecialidade] PRIMARY KEY CLUSTERED 
(
	[cd_servico] ASC,
	[cd_especialidade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_ServicoEspecialidade] ON [dbo].[ServicoEspecialidade]
(
	[cd_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ServicoEspecialidade_1] ON [dbo].[ServicoEspecialidade]
(
	[cd_especialidade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[ServicoEspecialidade]  WITH NOCHECK ADD  CONSTRAINT [FK_ServicoEspecialidade_ESPECIALIDADE] FOREIGN KEY([cd_especialidade])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[ServicoEspecialidade] CHECK CONSTRAINT [FK_ServicoEspecialidade_ESPECIALIDADE]
ALTER TABLE [dbo].[ServicoEspecialidade]  WITH NOCHECK ADD  CONSTRAINT [FK_ServicoEspecialidade_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[ServicoEspecialidade] CHECK CONSTRAINT [FK_ServicoEspecialidade_SERVICO]
