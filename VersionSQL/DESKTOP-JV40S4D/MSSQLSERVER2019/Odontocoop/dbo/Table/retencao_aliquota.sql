/****** Object:  Table [dbo].[retencao_aliquota]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[retencao_aliquota](
	[id_retencao_aliquota] [tinyint] NOT NULL,
	[ds_retencao_aliquota] [varchar](50) NOT NULL,
 CONSTRAINT [PK_incidencia_aliquota] PRIMARY KEY CLUSTERED 
(
	[id_retencao_aliquota] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
