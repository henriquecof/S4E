/****** Object:  Table [dbo].[Funcionario_BatePonto]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Funcionario_BatePonto](
	[cd_funcionario] [int] NOT NULL,
	[data_ponto] [datetime] NOT NULL,
	[periodo] [smallint] NOT NULL,
	[ip_maquina_ponto] [varchar](20) NULL,
	[batida_1turno] [datetime] NULL,
	[data_ponto_aux] [datetime] NULL,
	[fl_excluido] [bit] NULL,
	[justificativa] [varchar](50) NULL,
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[obs] [varchar](2000) NULL,
PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
