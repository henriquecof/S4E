/****** Object:  Table [dbo].[RegistroAuxiliaresESocial]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RegistroAuxiliaresESocial](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[evento] [int] NULL,
	[categoria] [int] NULL,
	[cbo] [int] NULL,
	[tipo] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
