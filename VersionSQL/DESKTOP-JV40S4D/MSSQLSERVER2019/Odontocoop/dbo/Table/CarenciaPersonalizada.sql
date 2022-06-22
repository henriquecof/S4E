/****** Object:  Table [dbo].[CarenciaPersonalizada]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CarenciaPersonalizada](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_servico] [int] NULL,
	[cd_especialidade] [int] NULL,
	[diasCarencia] [int] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
	[idGrupoCarencia] [int] NULL,
	[dataInicioVigencia] [date] NULL,
 CONSTRAINT [PK_CarenciaPersonalizada] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_CarenciaPersonalizada] ON [dbo].[CarenciaPersonalizada]
(
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CarenciaPersonalizada_1] ON [dbo].[CarenciaPersonalizada]
(
	[cd_sequencial_dep] ASC,
	[cd_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CarenciaPersonalizada_2] ON [dbo].[CarenciaPersonalizada]
(
	[cd_sequencial_dep] ASC,
	[cd_especialidade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CarenciaPersonalizada]  WITH CHECK ADD  CONSTRAINT [FK_CarenciaPersonalizada_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[CarenciaPersonalizada] CHECK CONSTRAINT [FK_CarenciaPersonalizada_DEPENDENTES]
ALTER TABLE [dbo].[CarenciaPersonalizada]  WITH CHECK ADD  CONSTRAINT [FK_CarenciaPersonalizada_ESPECIALIDADE] FOREIGN KEY([cd_especialidade])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[CarenciaPersonalizada] CHECK CONSTRAINT [FK_CarenciaPersonalizada_ESPECIALIDADE]
ALTER TABLE [dbo].[CarenciaPersonalizada]  WITH CHECK ADD  CONSTRAINT [FK_CarenciaPersonalizada_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[CarenciaPersonalizada] CHECK CONSTRAINT [FK_CarenciaPersonalizada_FUNCIONARIO]
ALTER TABLE [dbo].[CarenciaPersonalizada]  WITH CHECK ADD  CONSTRAINT [FK_CarenciaPersonalizada_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[CarenciaPersonalizada] CHECK CONSTRAINT [FK_CarenciaPersonalizada_FUNCIONARIO1]
ALTER TABLE [dbo].[CarenciaPersonalizada]  WITH CHECK ADD  CONSTRAINT [FK_CarenciaPersonalizada_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[CarenciaPersonalizada] CHECK CONSTRAINT [FK_CarenciaPersonalizada_SERVICO]
