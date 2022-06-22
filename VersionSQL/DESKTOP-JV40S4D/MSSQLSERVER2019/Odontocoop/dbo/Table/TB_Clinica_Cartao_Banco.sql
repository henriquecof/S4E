/****** Object:  Table [dbo].[TB_Clinica_Cartao_Banco]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Clinica_Cartao_Banco](
	[cd_filial] [int] NULL,
	[SequencialCartao_Car] [int] NOT NULL,
	[Sequencial_Movimentacao] [int] NOT NULL,
	[cd_centro_custo] [smallint] NOT NULL,
 CONSTRAINT [PK_TB_Clinica_Cartao_Banco] PRIMARY KEY CLUSTERED 
(
	[cd_centro_custo] ASC,
	[Sequencial_Movimentacao] ASC,
	[SequencialCartao_Car] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_Clinica_Cartao_Banco]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Clinica_Cartao_Banco_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[TB_Clinica_Cartao_Banco] CHECK CONSTRAINT [FK_TB_Clinica_Cartao_Banco_Centro_Custo]
ALTER TABLE [dbo].[TB_Clinica_Cartao_Banco]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Clinica_Cartao_Banco_TB_Cartao_Car] FOREIGN KEY([SequencialCartao_Car])
REFERENCES [dbo].[TB_Cartao_Car] ([SequencialCartao_Car])
ALTER TABLE [dbo].[TB_Clinica_Cartao_Banco] CHECK CONSTRAINT [FK_TB_Clinica_Cartao_Banco_TB_Cartao_Car]
ALTER TABLE [dbo].[TB_Clinica_Cartao_Banco]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Clinica_Cartao_Banco_TB_MovimentacaoFinanceira] FOREIGN KEY([Sequencial_Movimentacao])
REFERENCES [dbo].[TB_MovimentacaoFinanceira] ([Sequencial_Movimentacao])
ALTER TABLE [dbo].[TB_Clinica_Cartao_Banco] CHECK CONSTRAINT [FK_TB_Clinica_Cartao_Banco_TB_MovimentacaoFinanceira]
