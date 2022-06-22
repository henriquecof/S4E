/****** Object:  Table [dbo].[SulAmericaDependente]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SulAmericaDependente](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idDependente] [int] NULL,
	[operacao] [int] NULL,
	[valorPremio] [money] NULL,
	[apolice] [int] NULL,
	[sorteio] [int] NULL,
	[inicioVigencia] [datetime] NULL,
	[fimVigencia] [datetime] NULL,
	[operacaoParceiro] [varchar](50) NULL,
	[idFuncionaroInclusao] [int] NULL,
	[dataInclusao] [datetime] NULL,
	[idFuncionarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
	[erro] [varchar](350) NULL,
 CONSTRAINT [PK_SulAmericaDependente] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SulAmericaDependente]  WITH CHECK ADD  CONSTRAINT [FK_SulAmericaDependente_DEPENDENTES] FOREIGN KEY([idDependente])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[SulAmericaDependente] CHECK CONSTRAINT [FK_SulAmericaDependente_DEPENDENTES]
ALTER TABLE [dbo].[SulAmericaDependente]  WITH CHECK ADD  CONSTRAINT [FK_SulAmericaDependente_FUNCIONARIOEXC] FOREIGN KEY([idFuncionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[SulAmericaDependente] CHECK CONSTRAINT [FK_SulAmericaDependente_FUNCIONARIOEXC]
ALTER TABLE [dbo].[SulAmericaDependente]  WITH CHECK ADD  CONSTRAINT [FK_SulAmericaDependente_FUNCIONARIOINC] FOREIGN KEY([idFuncionaroInclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[SulAmericaDependente] CHECK CONSTRAINT [FK_SulAmericaDependente_FUNCIONARIOINC]
