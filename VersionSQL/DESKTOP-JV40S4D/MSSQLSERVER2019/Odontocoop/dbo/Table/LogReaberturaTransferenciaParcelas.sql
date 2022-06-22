/****** Object:  Table [dbo].[LogReaberturaTransferenciaParcelas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LogReaberturaTransferenciaParcelas](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UsuarioLogado] [int] NOT NULL,
	[DataCadastro] [datetime] NOT NULL,
	[CodParcela] [int] NOT NULL,
	[CodAssociaodo] [int] NOT NULL,
	[ValorPago] [money] NULL,
	[Multa] [money] NULL,
	[Juros] [money] NULL,
	[Acrescimo] [money] NULL,
	[Desconto] [money] NULL,
	[Imposto] [money] NULL,
	[CodParcelaDestino] [int] NULL,
	[CodAssociadoDestino] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LogReaberturaTransferenciaParcelas]  WITH CHECK ADD  CONSTRAINT [FK_LOG_REABERTURA_TRANSFERENCIA_PARCELAS_CodAssociadoDestino_ASSOCIADOS_CD_ASSOCIADO] FOREIGN KEY([CodAssociadoDestino])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[LogReaberturaTransferenciaParcelas] CHECK CONSTRAINT [FK_LOG_REABERTURA_TRANSFERENCIA_PARCELAS_CodAssociadoDestino_ASSOCIADOS_CD_ASSOCIADO]
ALTER TABLE [dbo].[LogReaberturaTransferenciaParcelas]  WITH CHECK ADD  CONSTRAINT [FK_LOG_REABERTURA_TRANSFERENCIA_PARCELAS_CodAssociaodo_ASSOCIADOS_CD_ASSOCIADO] FOREIGN KEY([CodAssociaodo])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[LogReaberturaTransferenciaParcelas] CHECK CONSTRAINT [FK_LOG_REABERTURA_TRANSFERENCIA_PARCELAS_CodAssociaodo_ASSOCIADOS_CD_ASSOCIADO]
ALTER TABLE [dbo].[LogReaberturaTransferenciaParcelas]  WITH CHECK ADD  CONSTRAINT [FK_LOG_REABERTURA_TRANSFERENCIA_PARCELAS_CodParcela_MENSALIDADES_CD_PARCELA] FOREIGN KEY([CodParcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[LogReaberturaTransferenciaParcelas] CHECK CONSTRAINT [FK_LOG_REABERTURA_TRANSFERENCIA_PARCELAS_CodParcela_MENSALIDADES_CD_PARCELA]
ALTER TABLE [dbo].[LogReaberturaTransferenciaParcelas]  WITH CHECK ADD  CONSTRAINT [FK_LOG_REABERTURA_TRANSFERENCIA_PARCELAS_CodParcelaDestino_MENSALIDADES_CD_PARCELA] FOREIGN KEY([CodParcelaDestino])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[LogReaberturaTransferenciaParcelas] CHECK CONSTRAINT [FK_LOG_REABERTURA_TRANSFERENCIA_PARCELAS_CodParcelaDestino_MENSALIDADES_CD_PARCELA]
ALTER TABLE [dbo].[LogReaberturaTransferenciaParcelas]  WITH CHECK ADD  CONSTRAINT [FK_LOG_REABERTURA_TRANSFERENCIA_PARCELAS_UsuarioLogado_FUNCIONARIO_cd_Funcionario] FOREIGN KEY([UsuarioLogado])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[LogReaberturaTransferenciaParcelas] CHECK CONSTRAINT [FK_LOG_REABERTURA_TRANSFERENCIA_PARCELAS_UsuarioLogado_FUNCIONARIO_cd_Funcionario]
