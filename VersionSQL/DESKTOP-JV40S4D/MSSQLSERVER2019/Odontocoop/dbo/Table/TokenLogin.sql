/****** Object:  Table [dbo].[TokenLogin]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TokenLogin](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[origemLogin] [int] NOT NULL,
	[codigo] [int] NOT NULL,
	[dataLogin] [datetime] NULL,
	[dataLogoff] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
