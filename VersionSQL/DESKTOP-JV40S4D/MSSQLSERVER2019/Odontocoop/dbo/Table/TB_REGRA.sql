/****** Object:  Table [dbo].[TB_REGRA]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_REGRA](
	[CODIGO_REGRA] [int] NOT NULL,
	[DESCRICAO] [varchar](1000) NULL,
	[Exige_CD_SERVICO] [smallint] NULL,
	[Exige_CD_SERVICO2] [smallint] NULL,
	[Exige_Faces] [smallint] NULL,
	[Exige_UD] [smallint] NULL,
	[Exige_QT_Meses] [smallint] NULL,
	[Exige_idade] [smallint] NULL,
	[Exige_Idade2] [smallint] NULL,
 CONSTRAINT [PK_TB_REGRA] PRIMARY KEY CLUSTERED 
(
	[CODIGO_REGRA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
