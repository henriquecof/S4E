/****** Object:  Table [dbo].[PNL_LocalAtendimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PNL_LocalAtendimento](
	[cd_LocalAtendimento] [int] IDENTITY(1,1) NOT NULL,
	[nm_LocalAtendimento] [varchar](100) NOT NULL,
	[status] [bit] NOT NULL,
 CONSTRAINT [PK_PainelLocalAtendimento] PRIMARY KEY CLUSTERED 
(
	[cd_LocalAtendimento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
