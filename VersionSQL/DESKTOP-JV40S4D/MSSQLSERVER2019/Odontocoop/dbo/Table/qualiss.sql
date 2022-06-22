/****** Object:  Table [dbo].[qualiss]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[qualiss](
	[cd_qualiss] [tinyint] NOT NULL,
	[nm_qualiss] [varchar](50) NOT NULL,
	[ativo] [bit] NULL,
 CONSTRAINT [PK_qualiss] PRIMARY KEY CLUSTERED 
(
	[cd_qualiss] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
