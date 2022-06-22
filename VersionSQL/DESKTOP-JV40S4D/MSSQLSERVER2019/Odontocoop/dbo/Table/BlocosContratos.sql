/****** Object:  Table [dbo].[BlocosContratos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BlocosContratos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[faixaInicial] [int] NOT NULL,
	[faixaFinal] [int] NOT NULL,
	[dataExclusao] [datetime] NULL,
	[usuarioExclusao] [int] NULL,
 CONSTRAINT [PK_BlocosContratos] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[BlocosContratos]  WITH CHECK ADD  CONSTRAINT [FK_BlocosContratos_BlocosContratos] FOREIGN KEY([cd_funcionario])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[BlocosContratos] CHECK CONSTRAINT [FK_BlocosContratos_BlocosContratos]
ALTER TABLE [dbo].[BlocosContratos]  WITH CHECK ADD  CONSTRAINT [FK_BlocosContratos_FUNCIONARIO] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[BlocosContratos] CHECK CONSTRAINT [FK_BlocosContratos_FUNCIONARIO]
ALTER TABLE [dbo].[BlocosContratos]  WITH CHECK ADD  CONSTRAINT [FK_BlocosContratos_FUNCIONARIO1] FOREIGN KEY([usuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[BlocosContratos] CHECK CONSTRAINT [FK_BlocosContratos_FUNCIONARIO1]
