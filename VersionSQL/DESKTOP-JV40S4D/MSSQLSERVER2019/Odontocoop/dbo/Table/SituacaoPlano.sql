/****** Object:  Table [dbo].[SituacaoPlano]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SituacaoPlano](
	[splId] [tinyint] NOT NULL,
	[splDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_SituacaoPlano] PRIMARY KEY CLUSTERED 
(
	[splId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
