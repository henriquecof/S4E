/****** Object:  Table [dbo].[LiberacaoCarencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LiberacaoCarencia](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_servico] [int] NULL,
	[cd_especialidade] [int] NULL,
	[gprId] [smallint] NULL,
	[usuarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[usuarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [cd_especialidade_cd_sequencial_dep] ON [dbo].[LiberacaoCarencia]
(
	[cd_sequencial_dep] ASC,
	[cd_especialidade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [cd_sequencial_dep] ON [dbo].[LiberacaoCarencia]
(
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [cd_sequencial_dep_cd_servico] ON [dbo].[LiberacaoCarencia]
(
	[cd_sequencial_dep] ASC,
	[cd_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [cd_sequencial_dep_gprId] ON [dbo].[LiberacaoCarencia]
(
	[cd_sequencial_dep] ASC,
	[gprId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[LiberacaoCarencia]  WITH CHECK ADD  CONSTRAINT [FK__Liberacao__cd_es__426EB62A] FOREIGN KEY([cd_especialidade])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[LiberacaoCarencia] CHECK CONSTRAINT [FK__Liberacao__cd_es__426EB62A]
ALTER TABLE [dbo].[LiberacaoCarencia]  WITH CHECK ADD  CONSTRAINT [FK__Liberacao__cd_es__52A51DF3] FOREIGN KEY([cd_especialidade])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[LiberacaoCarencia] CHECK CONSTRAINT [FK__Liberacao__cd_es__52A51DF3]
ALTER TABLE [dbo].[LiberacaoCarencia]  WITH CHECK ADD FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[LiberacaoCarencia]  WITH CHECK ADD FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[LiberacaoCarencia]  WITH CHECK ADD  CONSTRAINT [FK__Liberacao__cd_se__4362DA63] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[LiberacaoCarencia] CHECK CONSTRAINT [FK__Liberacao__cd_se__4362DA63]
ALTER TABLE [dbo].[LiberacaoCarencia]  WITH CHECK ADD  CONSTRAINT [FK__Liberacao__cd_se__5399422C] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[LiberacaoCarencia] CHECK CONSTRAINT [FK__Liberacao__cd_se__5399422C]
ALTER TABLE [dbo].[LiberacaoCarencia]  WITH CHECK ADD FOREIGN KEY([gprId])
REFERENCES [dbo].[GrupoProcedimento] ([gprId])
ALTER TABLE [dbo].[LiberacaoCarencia]  WITH CHECK ADD FOREIGN KEY([gprId])
REFERENCES [dbo].[GrupoProcedimento] ([gprId])
ALTER TABLE [dbo].[LiberacaoCarencia]  WITH CHECK ADD  CONSTRAINT [FK__Liberacao__usuar__463F470E] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[LiberacaoCarencia] CHECK CONSTRAINT [FK__Liberacao__usuar__463F470E]
ALTER TABLE [dbo].[LiberacaoCarencia]  WITH CHECK ADD  CONSTRAINT [FK__Liberacao__usuar__47336B47] FOREIGN KEY([usuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[LiberacaoCarencia] CHECK CONSTRAINT [FK__Liberacao__usuar__47336B47]
ALTER TABLE [dbo].[LiberacaoCarencia]  WITH CHECK ADD  CONSTRAINT [FK__Liberacao__usuar__5675AED7] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[LiberacaoCarencia] CHECK CONSTRAINT [FK__Liberacao__usuar__5675AED7]
ALTER TABLE [dbo].[LiberacaoCarencia]  WITH CHECK ADD  CONSTRAINT [FK__Liberacao__usuar__5769D310] FOREIGN KEY([usuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[LiberacaoCarencia] CHECK CONSTRAINT [FK__Liberacao__usuar__5769D310]
