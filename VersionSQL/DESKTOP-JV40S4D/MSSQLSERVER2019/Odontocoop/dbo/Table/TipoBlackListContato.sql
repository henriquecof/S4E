/****** Object:  Table [dbo].[TipoBlackListContato]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoBlackListContato](
	[tblcId] [tinyint] IDENTITY(1,1) NOT NULL,
	[tblcDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoBlackListContato] PRIMARY KEY CLUSTERED 
(
	[tblcId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
