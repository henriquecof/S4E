/****** Object:  Table [dbo].[MobileDevicesTypes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MobileDevicesTypes](
	[deviceTypeID] [int] IDENTITY(1,1) NOT NULL,
	[deviceTypeName] [varchar](45) NOT NULL,
	[registration] [datetime] NOT NULL,
	[nr_order] [varchar](45) NULL,
 CONSTRAINT [PK_MobileDevicesTypes] PRIMARY KEY CLUSTERED 
(
	[deviceTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
