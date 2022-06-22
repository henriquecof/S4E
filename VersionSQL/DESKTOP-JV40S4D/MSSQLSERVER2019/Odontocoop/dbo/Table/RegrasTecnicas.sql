/****** Object:  Table [dbo].[RegrasTecnicas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RegrasTecnicas](
	[rteId] [tinyint] IDENTITY(1,1) NOT NULL,
	[rteDescricao] [varchar](100) NOT NULL,
	[rteTexto] [varchar](250) NOT NULL,
	[acao] [tinyint] NULL,
 CONSTRAINT [PK_RegrasTecnicas] PRIMARY KEY CLUSTERED 
(
	[rteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
