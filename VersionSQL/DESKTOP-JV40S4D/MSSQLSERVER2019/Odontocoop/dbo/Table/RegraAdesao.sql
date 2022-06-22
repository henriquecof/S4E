/****** Object:  Table [dbo].[RegraAdesao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RegraAdesao](
	[Adesao] [int] NOT NULL,
	[Vigencia] [int] NOT NULL,
	[Vencimento] [int] NOT NULL,
 CONSTRAINT [PK_Adesao] PRIMARY KEY CLUSTERED 
(
	[Adesao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
