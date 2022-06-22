/****** Object:  Table [dbo].[TelefoniaFila]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TelefoniaFila](
	[tfiId] [int] NOT NULL,
	[tfiCodigo] [varchar](50) NOT NULL,
	[tfiDescricao] [varchar](50) NOT NULL,
	[tfiAtivo] [bit] NOT NULL,
	[tfiDtCadastro] [datetime] NOT NULL,
	[tfiDtExclusao] [datetime] NULL,
 CONSTRAINT [PK_TelefoniaFila] PRIMARY KEY CLUSTERED 
(
	[tfiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
