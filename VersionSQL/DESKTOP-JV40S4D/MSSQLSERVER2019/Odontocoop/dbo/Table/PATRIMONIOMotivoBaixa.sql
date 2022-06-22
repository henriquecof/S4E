/****** Object:  Table [dbo].[PATRIMONIOMotivoBaixa]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PATRIMONIOMotivoBaixa](
	[id_motivoBaixa] [int] IDENTITY(1,1) NOT NULL,
	[descricao_motivoBaixa] [varchar](200) NOT NULL,
 CONSTRAINT [PK_PATRIMONIOMotivoBaixa] PRIMARY KEY CLUSTERED 
(
	[id_motivoBaixa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
