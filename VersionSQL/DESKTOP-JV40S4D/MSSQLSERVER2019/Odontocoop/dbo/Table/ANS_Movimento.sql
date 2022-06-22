/****** Object:  Table [dbo].[ANS_Movimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ANS_Movimento](
	[cd_movimento] [smallint] IDENTITY(1,1) NOT NULL,
	[ds_movimento] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ANS_Movimento] PRIMARY KEY CLUSTERED 
(
	[cd_movimento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
