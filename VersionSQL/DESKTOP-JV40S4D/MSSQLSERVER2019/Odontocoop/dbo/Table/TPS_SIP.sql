/****** Object:  Table [dbo].[TPS_SIP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TPS_SIP](
	[competencia] [int] NOT NULL,
	[qt0] [int] NULL,
	[qt1] [int] NULL,
	[qt2] [int] NULL,
 CONSTRAINT [PK_TPS_SIP] PRIMARY KEY CLUSTERED 
(
	[competencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
