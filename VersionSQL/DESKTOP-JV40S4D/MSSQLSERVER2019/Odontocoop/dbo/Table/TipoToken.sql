/****** Object:  Table [dbo].[TipoToken]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoToken](
	[idTipoToken] [smallint] NOT NULL,
	[descricao] [varchar](max) NOT NULL,
 CONSTRAINT [PK_TipoToken] PRIMARY KEY CLUSTERED 
(
	[idTipoToken] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
