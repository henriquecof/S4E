/****** Object:  Table [dbo].[Convenio]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Convenio](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RazaoSocial] [varchar](100) NOT NULL,
	[CNPJ] [varchar](14) NULL,
	[NRANS] [varchar](20) NOT NULL,
	[Ativo] [bit] NOT NULL,
	[codigoPrestadorNaOperadora] [varchar](20) NULL,
 CONSTRAINT [PK_CONVENIO] PRIMARY KEY CLUSTERED 
(
	[Id] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
