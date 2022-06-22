/****** Object:  Table [dbo].[CRMSituacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMSituacao](
	[sitId] [tinyint] IDENTITY(1,1) NOT NULL,
	[sitDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CRMSituacao] PRIMARY KEY CLUSTERED 
(
	[sitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
