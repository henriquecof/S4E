/****** Object:  Table [dbo].[ANS_CAMPOS_TISS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ANS_CAMPOS_TISS](
	[idANS] [int] NOT NULL,
	[NomeCampo] [nvarchar](255) NOT NULL,
	[Tipo] [nvarchar](255) NULL,
	[Tamanho] [float] NULL,
	[Formato] [nvarchar](255) NULL,
	[Descricao] [nvarchar](2000) NULL,
	[Condicao] [nvarchar](max) NULL,
 CONSTRAINT [PK_idANS] PRIMARY KEY CLUSTERED 
(
	[idANS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
