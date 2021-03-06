/****** Object:  Table [dbo].[PerguntasRespostas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PerguntasRespostas](
	[cd_pergunta] [int] IDENTITY(1,1) NOT NULL,
	[ds_pergunta] [varchar](500) NOT NULL,
	[ds_resposta] [varchar](500) NULL,
	[cd_modulo] [int] NOT NULL,
 CONSTRAINT [PK_PerguntasRespostas_1] PRIMARY KEY CLUSTERED 
(
	[cd_pergunta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
