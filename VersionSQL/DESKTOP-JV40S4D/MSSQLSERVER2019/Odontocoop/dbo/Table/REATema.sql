/****** Object:  Table [dbo].[REATema]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[REATema](
	[rteId] [tinyint] NOT NULL,
	[rteDescricao] [varchar](50) NOT NULL,
	[rteAtivo] [bit] NOT NULL,
 CONSTRAINT [PK_REATema] PRIMARY KEY CLUSTERED 
(
	[rteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
