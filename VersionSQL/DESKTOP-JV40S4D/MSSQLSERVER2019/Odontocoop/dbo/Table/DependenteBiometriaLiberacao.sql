/****** Object:  Table [dbo].[DependenteBiometriaLiberacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DependenteBiometriaLiberacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[dt_inicio] [datetime] NOT NULL,
	[dt_fim] [datetime] NOT NULL,
	[cd_funcionario_cadastro] [int] NOT NULL,
	[cd_funcionario_exclusao] [int] NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[dt_exclusao] [datetime] NULL,
 CONSTRAINT [PK_DependenteBiometriaLiberacao] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DependenteBiometriaLiberacao]  WITH CHECK ADD  CONSTRAINT [FK_DependenteBiometriaLiberacao_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[DependenteBiometriaLiberacao] CHECK CONSTRAINT [FK_DependenteBiometriaLiberacao_DEPENDENTES]
ALTER TABLE [dbo].[DependenteBiometriaLiberacao]  WITH CHECK ADD  CONSTRAINT [FK_DependenteBiometriaLiberacao_FUNCIONARIO] FOREIGN KEY([cd_funcionario_cadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[DependenteBiometriaLiberacao] CHECK CONSTRAINT [FK_DependenteBiometriaLiberacao_FUNCIONARIO]
ALTER TABLE [dbo].[DependenteBiometriaLiberacao]  WITH CHECK ADD  CONSTRAINT [FK_DependenteBiometriaLiberacao_FUNCIONARIO1] FOREIGN KEY([cd_funcionario_exclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[DependenteBiometriaLiberacao] CHECK CONSTRAINT [FK_DependenteBiometriaLiberacao_FUNCIONARIO1]
