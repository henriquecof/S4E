/****** Object:  Table [dbo].[arquivoImportacaoLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[arquivoImportacaoLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Arquivo] [varchar](400) NULL,
	[Info] [varchar](max) NULL,
	[NumLinhaArquivo] [int] NULL,
	[LinhaArquivoText] [varchar](max) NULL,
	[ErrorNumber] [int] NULL,
	[ErrorLine] [int] NULL,
	[ErrorMessage] [varchar](max) NULL,
	[DataHora] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
