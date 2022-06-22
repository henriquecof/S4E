/****** Object:  Table [dbo].[Modelo_PgtoPrestador_Aliquota]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Modelo_PgtoPrestador_Aliquota](
	[cd_modelo_pgto_prestador] [smallint] NOT NULL,
	[cd_aliquota] [smallint] NOT NULL,
	[perc_incidencia] [float] NOT NULL,
	[cd_conta] [int] NOT NULL,
	[id_retencao_aliquota] [tinyint] NOT NULL,
	[sequencial_movimentacao] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[Modelo_PgtoPrestador_Aliquota]  WITH NOCHECK ADD  CONSTRAINT [FK_Modelo_PgtoPrestador_Aliquota_Aliquota] FOREIGN KEY([cd_aliquota])
REFERENCES [dbo].[Aliquota] ([cd_aliquota])
ALTER TABLE [dbo].[Modelo_PgtoPrestador_Aliquota] CHECK CONSTRAINT [FK_Modelo_PgtoPrestador_Aliquota_Aliquota]
ALTER TABLE [dbo].[Modelo_PgtoPrestador_Aliquota]  WITH NOCHECK ADD  CONSTRAINT [FK_Modelo_PgtoPrestador_Aliquota_Modelo_Pagamento_Prestador] FOREIGN KEY([cd_modelo_pgto_prestador])
REFERENCES [dbo].[Modelo_Pagamento_Prestador] ([cd_modelo_pgto_prestador])
ALTER TABLE [dbo].[Modelo_PgtoPrestador_Aliquota] CHECK CONSTRAINT [FK_Modelo_PgtoPrestador_Aliquota_Modelo_Pagamento_Prestador]
