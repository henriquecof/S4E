﻿/****** Object:  Table [dbo].[MobileAccessScreen]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MobileAccessScreen](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idMobileUsersDevices] [int] NULL,
	[date] [datetime] NULL,
	[page] [int] NULL,
 CONSTRAINT [PK_MobileAccessScreen] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
