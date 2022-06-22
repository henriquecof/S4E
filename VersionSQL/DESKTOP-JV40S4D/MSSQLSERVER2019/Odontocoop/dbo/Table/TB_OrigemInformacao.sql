/****** Object:  Table [dbo].[TB_OrigemInformacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_OrigemInformacao](
	[cd_origeminformacao] [int] NOT NULL,
	[nm_origeminformacao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TB_OrigemInformacao] PRIMARY KEY CLUSTERED 
(
	[cd_origeminformacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
