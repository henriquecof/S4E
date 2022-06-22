/****** Object:  Table [dbo].[LogErro]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LogErro](
	[lerId] [int] IDENTITY(1,1) NOT NULL,
	[lerErro] [varchar](max) NULL,
	[lerSQL] [varchar](max) NULL,
	[lerURL] [varchar](200) NULL,
	[lerParametros] [varchar](200) NULL,
	[lerDtInclusao] [datetime] NOT NULL,
	[lerIP] [varchar](15) NULL,
	[lerNavegador] [varchar](200) NULL,
	[TipoUsuario] [tinyint] NULL,
	[Usuario] [int] NULL,
 CONSTRAINT [PK_TB_LogErro] PRIMARY KEY CLUSTERED 
(
	[lerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
