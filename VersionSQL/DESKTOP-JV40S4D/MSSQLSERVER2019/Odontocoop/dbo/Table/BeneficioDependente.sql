/****** Object:  Table [dbo].[BeneficioDependente]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BeneficioDependente](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idBeneficio] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[dataInclusao] [datetime] NOT NULL,
	[usuarioInclusao] [int] NOT NULL,
	[dataExclusao] [datetime] NULL,
	[usuarioExclusao] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[BeneficioDependente]  WITH CHECK ADD  CONSTRAINT [FK_Beneficio_id_BeneficioDependente_idBeneficio] FOREIGN KEY([idBeneficio])
REFERENCES [dbo].[Beneficio] ([id])
ALTER TABLE [dbo].[BeneficioDependente] CHECK CONSTRAINT [FK_Beneficio_id_BeneficioDependente_idBeneficio]
ALTER TABLE [dbo].[BeneficioDependente]  WITH CHECK ADD  CONSTRAINT [FK_Dependentes_cd_sequencial_BeneficioDependente_cd_sequencial_dep] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[BeneficioDependente] CHECK CONSTRAINT [FK_Dependentes_cd_sequencial_BeneficioDependente_cd_sequencial_dep]
ALTER TABLE [dbo].[BeneficioDependente]  WITH CHECK ADD  CONSTRAINT [FK_Funcionario_cd_funcionario_BeneficioDependente_usuarioExclusao] FOREIGN KEY([usuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[BeneficioDependente] CHECK CONSTRAINT [FK_Funcionario_cd_funcionario_BeneficioDependente_usuarioExclusao]
ALTER TABLE [dbo].[BeneficioDependente]  WITH CHECK ADD  CONSTRAINT [FK_Funcionario_cd_funcionario_BeneficioDependente_usuarioInclusao] FOREIGN KEY([usuarioInclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[BeneficioDependente] CHECK CONSTRAINT [FK_Funcionario_cd_funcionario_BeneficioDependente_usuarioInclusao]
