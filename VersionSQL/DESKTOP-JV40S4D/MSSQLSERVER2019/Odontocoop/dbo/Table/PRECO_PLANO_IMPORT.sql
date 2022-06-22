/****** Object:  Table [dbo].[PRECO_PLANO_IMPORT]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PRECO_PLANO_IMPORT](
	[CD_PLANO] [float] NULL,
	[DESC_PLANO] [nvarchar](255) NULL,
	[CD_EMPRESA] [float] NULL,
	[NOME_EMPRESA] [nvarchar](255) NULL,
	[DT_INICIO] [datetime] NULL,
	[DT_FIM_COMERCIALIZACAO] [datetime] NULL,
	[VL_TIT] [float] NULL,
	[VL_DEP] [float] NULL,
	[FL_EXIGE_ADESAO] [float] NULL,
	[FL_VALOR_FIXO] [float] NULL,
	[VL_BASE_COMISSAO_TIT] [float] NULL,
	[VL_BASE_COMISSAO_DEP] [float] NULL,
	[VL_ADESAO_TIT] [float] NULL,
	[VL_ADESAO_DEP] [float] NULL,
	[QT_DIAS_ADESAO] [float] NULL,
	[OBSERVAÇÕES] [float] NULL,
	[CD_TIPO_PAGAMENTO_ADESAO] [float] NULL
) ON [PRIMARY]
