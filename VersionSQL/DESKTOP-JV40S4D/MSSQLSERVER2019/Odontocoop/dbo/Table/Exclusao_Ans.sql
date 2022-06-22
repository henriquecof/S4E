/****** Object:  Table [dbo].[Exclusao_Ans]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Exclusao_Ans](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_associado] [int] NULL,
	[cd_empresa] [int] NULL,
 CONSTRAINT [PK_Exclusao_Ans_1] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
