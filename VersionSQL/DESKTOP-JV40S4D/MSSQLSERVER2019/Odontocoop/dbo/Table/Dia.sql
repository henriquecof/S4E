/****** Object:  Table [dbo].[Dia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Dia](
	[CD_DIA] [smallint] NOT NULL,
	[NM_DIARESUMIDO] [varchar](5) NOT NULL,
	[NM_DIA] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Dia] PRIMARY KEY CLUSTERED 
(
	[CD_DIA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
