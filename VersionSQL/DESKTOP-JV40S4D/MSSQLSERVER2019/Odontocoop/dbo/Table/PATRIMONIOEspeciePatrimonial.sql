/****** Object:  Table [dbo].[PATRIMONIOEspeciePatrimonial]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PATRIMONIOEspeciePatrimonial](
	[id_especiePatrimonial] [int] IDENTITY(1,1) NOT NULL,
	[descricao_especiePatrimonial] [varchar](200) NOT NULL,
 CONSTRAINT [PK_PATRIMONIOEspeciePatrimonial] PRIMARY KEY CLUSTERED 
(
	[id_especiePatrimonial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
