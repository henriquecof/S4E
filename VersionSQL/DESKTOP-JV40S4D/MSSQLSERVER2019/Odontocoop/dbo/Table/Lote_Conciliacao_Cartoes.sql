/****** Object:  Table [dbo].[Lote_Conciliacao_Cartoes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_Conciliacao_Cartoes](
	[lccId] [int] IDENTITY(1,1) NOT NULL,
	[lccDtInicial] [datetime] NOT NULL,
	[lccDtFinal] [datetime] NOT NULL,
	[lccDtCadastro] [datetime] NOT NULL,
	[cd_funcionario_cadastro] [int] NULL,
	[lccDtFechado] [datetime] NULL,
	[lccDtEnvio] [datetime] NULL,
	[cd_funcionario_fechou] [int] NULL,
	[cd_centro_custo] [smallint] NULL,
	[lccRequisicao] [varchar](50) NULL,
	[conciliadorId] [int] NULL,
 CONSTRAINT [PK_Lote_Conciliacao_Cartoes] PRIMARY KEY CLUSTERED 
(
	[lccId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Lote_Conciliacao_Cartoes]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Conciliacao_Cartoes_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[Lote_Conciliacao_Cartoes] CHECK CONSTRAINT [FK_Lote_Conciliacao_Cartoes_Centro_Custo]
ALTER TABLE [dbo].[Lote_Conciliacao_Cartoes]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Conciliacao_Cartoes_FUNCIONARIO] FOREIGN KEY([cd_funcionario_cadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_Conciliacao_Cartoes] CHECK CONSTRAINT [FK_Lote_Conciliacao_Cartoes_FUNCIONARIO]
ALTER TABLE [dbo].[Lote_Conciliacao_Cartoes]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Conciliacao_Cartoes_FUNCIONARIO1] FOREIGN KEY([cd_funcionario_fechou])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_Conciliacao_Cartoes] CHECK CONSTRAINT [FK_Lote_Conciliacao_Cartoes_FUNCIONARIO1]
