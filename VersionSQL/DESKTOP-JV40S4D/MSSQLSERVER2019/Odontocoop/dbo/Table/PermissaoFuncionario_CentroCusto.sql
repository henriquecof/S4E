/****** Object:  Table [dbo].[PermissaoFuncionario_CentroCusto]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PermissaoFuncionario_CentroCusto](
	[cd_funcionario] [int] NOT NULL,
	[cd_centro_custo] [smallint] NOT NULL,
 CONSTRAINT [PK_PermissaoFuncionario_CentroCusto] PRIMARY KEY CLUSTERED 
(
	[cd_funcionario] ASC,
	[cd_centro_custo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PermissaoFuncionario_CentroCusto]  WITH NOCHECK ADD  CONSTRAINT [FK_PermissaoFuncionario_CentroCusto_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[PermissaoFuncionario_CentroCusto] CHECK CONSTRAINT [FK_PermissaoFuncionario_CentroCusto_Centro_Custo]
