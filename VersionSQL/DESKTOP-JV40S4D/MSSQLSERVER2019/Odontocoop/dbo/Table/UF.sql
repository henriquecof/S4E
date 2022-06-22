/****** Object:  Table [dbo].[UF]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UF](
	[ufId] [smallint] NOT NULL,
	[ufDescricao] [varchar](100) NOT NULL,
	[ufSigla] [varchar](2) NOT NULL,
	[regiao] [char](2) NULL,
	[codigoUfIBGE] [tinyint] NULL,
 CONSTRAINT [PK_UF] PRIMARY KEY CLUSTERED 
(
	[ufId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
