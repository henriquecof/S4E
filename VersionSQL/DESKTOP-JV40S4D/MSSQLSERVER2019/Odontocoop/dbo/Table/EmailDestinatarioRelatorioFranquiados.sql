/****** Object:  Table [dbo].[EmailDestinatarioRelatorioFranquiados]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmailDestinatarioRelatorioFranquiados](
	[edrID] [int] IDENTITY(1,1) NOT NULL,
	[edrNome] [varchar](50) NOT NULL,
	[edrEmail] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EmailDestinatarioRelatorioFranquiados] PRIMARY KEY CLUSTERED 
(
	[edrID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
