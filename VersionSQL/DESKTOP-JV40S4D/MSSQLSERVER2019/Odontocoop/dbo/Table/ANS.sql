/****** Object:  Table [dbo].[ANS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ANS](
	[cd_sequencial] [int] NOT NULL,
	[dt_preparacao] [datetime] NOT NULL,
	[dt_envio] [datetime] NULL,
	[dt_retorno] [datetime] NULL,
	[dt_fechado] [datetime] NULL,
	[qt_reg_inclusao] [int] NULL,
	[qt_reg_exclusao] [int] NULL,
	[qt_reg_retificacao] [int] NULL,
	[qt_reg_mudanca] [int] NULL,
	[qt_reg_reativacao] [int] NULL,
	[qt_reg_inclusao_ret] [int] NULL,
	[qt_reg_exclusao_ret] [int] NULL,
	[qt_reg_retificacao_ret] [int] NULL,
	[qt_reg_mudanca_ret] [int] NULL,
	[qt_reg_reativacao_Ret] [int] NULL,
	[Perc_Acerto] [float] NULL,
	[nm_arquivo] [varchar](50) NULL,
	[nm_arquivo_envio] [varchar](50) NULL,
	[competencia] [varchar](6) NULL,
	[erro] [text] NULL,
 CONSTRAINT [PK_ANS] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
