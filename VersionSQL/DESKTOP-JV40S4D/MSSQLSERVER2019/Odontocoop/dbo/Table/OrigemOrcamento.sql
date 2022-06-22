/****** Object:  Table [dbo].[OrigemOrcamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrigemOrcamento](
	[cd_origemOrcamento] [int] NOT NULL,
	[nm_origemOrcamento] [varchar](50) NOT NULL,
 CONSTRAINT [PK_OrigemOrcamento] PRIMARY KEY CLUSTERED 
(
	[cd_origemOrcamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
