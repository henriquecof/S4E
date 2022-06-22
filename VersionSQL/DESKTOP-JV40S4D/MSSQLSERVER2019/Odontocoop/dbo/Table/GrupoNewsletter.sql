/****** Object:  Table [dbo].[GrupoNewsletter]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoNewsletter](
	[gnwId] [int] NOT NULL,
	[gnwDescricao] [varchar](200) NULL,
 CONSTRAINT [PK_GrupoNewsletter] PRIMARY KEY CLUSTERED 
(
	[gnwId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
