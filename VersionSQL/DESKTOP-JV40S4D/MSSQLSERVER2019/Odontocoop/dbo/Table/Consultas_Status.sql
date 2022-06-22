/****** Object:  Table [dbo].[Consultas_Status]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Consultas_Status](
	[Status] [int] NOT NULL,
	[Descricao] [varchar](1000) NOT NULL,
	[OBS] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_Consulta_Status] PRIMARY KEY CLUSTERED 
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
