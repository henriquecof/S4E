/****** Object:  Table [dbo].[Rota]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Rota](
	[cd_sequencial_rota] [int] IDENTITY(1,1) NOT NULL,
	[nm_rota] [varchar](100) NOT NULL,
	[fl_ativo] [bit] NOT NULL,
 CONSTRAINT [PK_Rota] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_rota] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
