/****** Object:  Table [dbo].[Lote_NfeLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_NfeLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[lnfId] [int] NOT NULL,
	[ultimoCodigoNFe] [bigint] NOT NULL,
 CONSTRAINT [PK_Lote_NfeLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
