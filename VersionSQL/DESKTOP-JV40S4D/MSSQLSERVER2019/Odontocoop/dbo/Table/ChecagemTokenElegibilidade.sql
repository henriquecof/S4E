/****** Object:  Table [dbo].[ChecagemTokenElegibilidade]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ChecagemTokenElegibilidade](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idDependente] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[usuarioCadastro] [int] NULL,
	[token] [varchar](50) NOT NULL,
	[telefone] [varchar](50) NULL,
	[idDentista] [int] NULL,
	[idFilial] [int] NULL,
	[dataAutenticacao] [datetime] NULL,
	[dataExclusao] [datetime] NULL,
	[idElegibilidade] [int] NOT NULL,
 CONSTRAINT [PK_ChecagemTokenElegibilidade] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ChecagemTokenElegibilidade]  WITH CHECK ADD  CONSTRAINT [FK_ChecagemTokenElegibilidade_DEPENDENTES] FOREIGN KEY([idDependente])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[ChecagemTokenElegibilidade] CHECK CONSTRAINT [FK_ChecagemTokenElegibilidade_DEPENDENTES]
ALTER TABLE [dbo].[ChecagemTokenElegibilidade]  WITH CHECK ADD  CONSTRAINT [FK_ChecagemTokenElegibilidade_FILIAL] FOREIGN KEY([idFilial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[ChecagemTokenElegibilidade] CHECK CONSTRAINT [FK_ChecagemTokenElegibilidade_FILIAL]
ALTER TABLE [dbo].[ChecagemTokenElegibilidade]  WITH CHECK ADD  CONSTRAINT [FK_ChecagemTokenElegibilidade_FUNCIONARIO] FOREIGN KEY([idDentista])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ChecagemTokenElegibilidade] CHECK CONSTRAINT [FK_ChecagemTokenElegibilidade_FUNCIONARIO]
