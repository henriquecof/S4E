/****** Object:  Table [dbo].[Abrangencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Abrangencia](
	[cd_abrangencia] [int] NOT NULL,
	[ds_abrangencia] [varchar](50) NULL,
 CONSTRAINT [PK_Abrangencia] PRIMARY KEY CLUSTERED 
(
	[cd_abrangencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
