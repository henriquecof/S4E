/****** Object:  Table [dbo].[VIP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[VIP](
	[fl_vip] [smallint] IDENTITY(1,1) NOT NULL,
	[ds_vip] [varchar](50) NOT NULL,
	[cd_origeminformacao] [int] NULL,
 CONSTRAINT [PK_VIP] PRIMARY KEY CLUSTERED 
(
	[fl_vip] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
