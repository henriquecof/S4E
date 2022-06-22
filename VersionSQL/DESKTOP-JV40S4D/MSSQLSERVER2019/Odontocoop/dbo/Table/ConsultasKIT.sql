/****** Object:  Table [dbo].[ConsultasKIT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ConsultasKIT](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_servico] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
 CONSTRAINT [PK_ConsultasKIT] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ConsultasKIT]  WITH CHECK ADD  CONSTRAINT [FK_ConsultasKIT_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[ConsultasKIT] CHECK CONSTRAINT [FK_ConsultasKIT_DEPENDENTES]
ALTER TABLE [dbo].[ConsultasKIT]  WITH CHECK ADD  CONSTRAINT [FK_ConsultasKIT_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ConsultasKIT] CHECK CONSTRAINT [FK_ConsultasKIT_FUNCIONARIO]
ALTER TABLE [dbo].[ConsultasKIT]  WITH CHECK ADD  CONSTRAINT [FK_ConsultasKIT_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ConsultasKIT] CHECK CONSTRAINT [FK_ConsultasKIT_FUNCIONARIO1]
ALTER TABLE [dbo].[ConsultasKIT]  WITH CHECK ADD  CONSTRAINT [FK_ConsultasKIT_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[ConsultasKIT] CHECK CONSTRAINT [FK_ConsultasKIT_SERVICO]
