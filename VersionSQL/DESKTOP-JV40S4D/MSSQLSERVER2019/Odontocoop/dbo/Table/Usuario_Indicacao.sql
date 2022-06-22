/****** Object:  Table [dbo].[Usuario_Indicacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Usuario_Indicacao](
	[Cd_associado_indicador] [int] NOT NULL,
	[valor] [money] NULL,
	[parcela] [int] NULL,
	[dt_cadastro] [datetime] NULL,
	[Cd_associado] [int] NOT NULL,
	[fl_indicacaoNaoUtilizada] [tinyint] NULL,
	[dt_processamento] [datetime] NULL,
	[dataProcessamentoOrto] [datetime] NULL,
	[dataProcessamentoOrcamento] [datetime] NULL,
 CONSTRAINT [PK_Usuario_Indicacao] PRIMARY KEY CLUSTERED 
(
	[Cd_associado_indicador] ASC,
	[Cd_associado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
