/****** Object:  Table [dbo].[Modelo_MicroCredito]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Modelo_MicroCredito](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_centro_custo] [smallint] NOT NULL,
	[valorInicialEntrada] [money] NOT NULL,
	[valorFinalEntrada] [money] NOT NULL,
	[numeroMaxParcela] [int] NULL,
	[dataCadastro] [datetime] NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[dataExclusao] [datetime] NULL,
	[usuarioExclusao] [int] NULL,
	[multiplicadorCreditoNiv0] [money] NOT NULL,
	[qtdeRestricoesNiv0] [int] NULL,
	[multiplicadorCreditoNiv1] [money] NOT NULL,
	[qtdeRestricoesNiv1] [int] NULL,
	[multiplicadorCreditoNiv2] [money] NOT NULL,
	[qtdeRestricoesNiv2] [int] NULL,
	[multiplicadorCreditoNiv3] [money] NOT NULL,
	[qtdeRestricoesNiv3] [int] NULL,
	[creditoNegado] [bit] NULL,
	[CNAEs_Restritivos] [varchar](1000) NULL,
 CONSTRAINT [PK_Modelo_MicroCredito] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Modelo_MicroCredito]  WITH CHECK ADD  CONSTRAINT [FK_Modelo_MicroCredito_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[Modelo_MicroCredito] CHECK CONSTRAINT [FK_Modelo_MicroCredito_Centro_Custo]
ALTER TABLE [dbo].[Modelo_MicroCredito]  WITH CHECK ADD  CONSTRAINT [FK_Modelo_MicroCredito_FUNCIONARIO] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Modelo_MicroCredito] CHECK CONSTRAINT [FK_Modelo_MicroCredito_FUNCIONARIO]
ALTER TABLE [dbo].[Modelo_MicroCredito]  WITH CHECK ADD  CONSTRAINT [FK_Modelo_MicroCredito_FUNCIONARIO1] FOREIGN KEY([usuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Modelo_MicroCredito] CHECK CONSTRAINT [FK_Modelo_MicroCredito_FUNCIONARIO1]
