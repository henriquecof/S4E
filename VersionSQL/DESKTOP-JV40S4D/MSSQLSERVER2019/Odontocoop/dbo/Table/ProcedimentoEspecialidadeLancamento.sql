/****** Object:  Table [dbo].[ProcedimentoEspecialidadeLancamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ProcedimentoEspecialidadeLancamento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_servico] [int] NOT NULL,
	[cd_especialidade] [int] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
 CONSTRAINT [PK_ProcedimentoEspecialidadeLancamento] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_ProcedimentoEspecialidadeLancamento] ON [dbo].[ProcedimentoEspecialidadeLancamento]
(
	[cd_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ProcedimentoEspecialidadeLancamento_1] ON [dbo].[ProcedimentoEspecialidadeLancamento]
(
	[cd_especialidade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[ProcedimentoEspecialidadeLancamento]  WITH CHECK ADD  CONSTRAINT [FK_ProcedimentoEspecialidadeLancamento_ESPECIALIDADE] FOREIGN KEY([cd_especialidade])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[ProcedimentoEspecialidadeLancamento] CHECK CONSTRAINT [FK_ProcedimentoEspecialidadeLancamento_ESPECIALIDADE]
ALTER TABLE [dbo].[ProcedimentoEspecialidadeLancamento]  WITH CHECK ADD  CONSTRAINT [FK_ProcedimentoEspecialidadeLancamento_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ProcedimentoEspecialidadeLancamento] CHECK CONSTRAINT [FK_ProcedimentoEspecialidadeLancamento_FUNCIONARIO1]
ALTER TABLE [dbo].[ProcedimentoEspecialidadeLancamento]  WITH CHECK ADD  CONSTRAINT [FK_ProcedimentoEspecialidadeLancamento_FUNCIONARIO2] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ProcedimentoEspecialidadeLancamento] CHECK CONSTRAINT [FK_ProcedimentoEspecialidadeLancamento_FUNCIONARIO2]
ALTER TABLE [dbo].[ProcedimentoEspecialidadeLancamento]  WITH CHECK ADD  CONSTRAINT [FK_ProcedimentoEspecialidadeLancamento_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[ProcedimentoEspecialidadeLancamento] CHECK CONSTRAINT [FK_ProcedimentoEspecialidadeLancamento_SERVICO]
