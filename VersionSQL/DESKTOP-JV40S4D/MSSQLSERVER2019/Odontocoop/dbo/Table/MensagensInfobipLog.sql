/****** Object:  Table [dbo].[MensagensInfobipLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MensagensInfobipLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[infobipId] [varchar](50) NULL,
	[telefone] [varchar](50) NULL,
	[mensagem] [text] NULL,
	[dataRecebimento] [datetime] NULL,
 CONSTRAINT [PK_MensagensInfobipLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
