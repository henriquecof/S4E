/****** Object:  Table [dbo].[ServicoLaboratorioProtese]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ServicoLaboratorioProtese](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_servicoPrincipal] [int] NOT NULL,
	[cd_servicoCorrelacionado] [int] NOT NULL,
	[tipoProcedimento] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
 CONSTRAINT [PK_ServicoLaboratorioProtese] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ServicoLaboratorioProtese]  WITH CHECK ADD  CONSTRAINT [FK_ServicoLaboratorioProtese_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ServicoLaboratorioProtese] CHECK CONSTRAINT [FK_ServicoLaboratorioProtese_FUNCIONARIO]
ALTER TABLE [dbo].[ServicoLaboratorioProtese]  WITH CHECK ADD  CONSTRAINT [FK_ServicoLaboratorioProtese_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ServicoLaboratorioProtese] CHECK CONSTRAINT [FK_ServicoLaboratorioProtese_FUNCIONARIO1]
ALTER TABLE [dbo].[ServicoLaboratorioProtese]  WITH CHECK ADD  CONSTRAINT [FK_ServicoLaboratorioProtese_SERVICO] FOREIGN KEY([cd_servicoPrincipal])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[ServicoLaboratorioProtese] CHECK CONSTRAINT [FK_ServicoLaboratorioProtese_SERVICO]
ALTER TABLE [dbo].[ServicoLaboratorioProtese]  WITH CHECK ADD  CONSTRAINT [FK_ServicoLaboratorioProtese_SERVICO1] FOREIGN KEY([cd_servicoCorrelacionado])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[ServicoLaboratorioProtese] CHECK CONSTRAINT [FK_ServicoLaboratorioProtese_SERVICO1]
