/****** Object:  Table [dbo].[tbAtendimentoRestricaoAcao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tbAtendimentoRestricaoAcao](
	[araID] [tinyint] IDENTITY(1,1) NOT NULL,
	[araDescricao] [varchar](20) NOT NULL,
 CONSTRAINT [PK_tbAtendimentoRestricaoAcao] PRIMARY KEY CLUSTERED 
(
	[araID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
