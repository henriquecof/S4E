/****** Object:  Table [dbo].[Parcela_coelce]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Parcela_coelce](
	[cd_parcela] [int] NOT NULL,
	[cd_sequencial_retorno] [int] NULL,
 CONSTRAINT [PK_Parcela_coelce] PRIMARY KEY CLUSTERED 
(
	[cd_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
