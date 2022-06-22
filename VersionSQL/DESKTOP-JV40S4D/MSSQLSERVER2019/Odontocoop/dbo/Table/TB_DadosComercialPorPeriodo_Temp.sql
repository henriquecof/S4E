/****** Object:  Table [dbo].[TB_DadosComercialPorPeriodo_Temp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_DadosComercialPorPeriodo_Temp](
	[cd_filial] [int] NULL,
	[nm_filial] [varchar](50) NULL,
	[Ano] [int] NULL,
	[Mes] [int] NULL,
	[Quantidade] [int] NULL,
	[Valor] [money] NULL,
	[QuantidadeCancelado] [int] NULL,
	[ValorCancelado] [money] NULL,
	[QuantidadeImportado] [int] NULL,
	[ValorImportado] [money] NULL
) ON [PRIMARY]
