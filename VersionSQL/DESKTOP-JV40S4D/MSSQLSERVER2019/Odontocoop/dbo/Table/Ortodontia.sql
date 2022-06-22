/****** Object:  Table [dbo].[Ortodontia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Ortodontia](
	[cd_filial] [int] NULL,
	[nm_razsoc] [varchar](100) NULL,
	[cd_associado] [int] NULL,
	[nm_dependente] [varchar](100) NULL,
	[dt_inicio] [datetime] NULL,
	[vl_servico] [money] NULL,
	[cd_funcionario] [int] NULL,
	[nm_empregado] [varchar](100) NULL,
	[dt_venciment] [datetime] NULL,
	[dt_ultorto] [datetime] NULL,
	[dt_consulta] [datetime] NULL,
	[fl_inc] [bit] NULL,
	[id] [int] NOT NULL,
	[nm_situacao] [varchar](50) NOT NULL,
	[cd_centro_custo] [int] NULL,
	[dt_kit] [varchar](50) NULL,
	[qt_pagas] [int] NULL,
	[qt_consultas] [int] NULL,
 CONSTRAINT [PK_Ortodontia] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
