/****** Object:  Table [dbo].[TB_Contrato]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Contrato](
	[sequencial_contrato] [smallint] IDENTITY(1,1) NOT NULL,
	[descricao_contrato] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TB_Contrato] PRIMARY KEY CLUSTERED 
(
	[sequencial_contrato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
