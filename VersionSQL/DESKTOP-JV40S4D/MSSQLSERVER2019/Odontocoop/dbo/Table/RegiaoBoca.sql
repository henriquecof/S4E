/****** Object:  Table [dbo].[RegiaoBoca]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RegiaoBoca](
	[rboId] [tinyint] NOT NULL,
	[rboDescricao] [varchar](50) NOT NULL,
	[rboSigla] [varchar](10) NOT NULL,
	[rboAtivo] [bit] NOT NULL,
	[rboUd] [varchar](20) NULL,
 CONSTRAINT [PK_RegiaoBoca] PRIMARY KEY CLUSTERED 
(
	[rboId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
