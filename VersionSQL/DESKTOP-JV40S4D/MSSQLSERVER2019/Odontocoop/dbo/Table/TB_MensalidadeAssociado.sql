/****** Object:  Table [dbo].[TB_MensalidadeAssociado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_MensalidadeAssociado](
	[Sequencial_MensalidadeAssociado] [int] IDENTITY(1,1) NOT NULL,
	[cd_parcela] [int] NOT NULL,
	[tipo_mensalidade_gerada] [smallint] NOT NULL,
	[Sequencial_Lancamento] [int] NOT NULL,
	[data_exclusao] [smalldatetime] NULL,
	[vl_desconto] [numeric](18, 2) NULL,
	[nome_usuario] [varchar](20) NULL,
	[Mensalidade_Nova] [smallint] NULL,
	[vl_acrescimo] [numeric](18, 2) NULL
) ON [PRIMARY]
