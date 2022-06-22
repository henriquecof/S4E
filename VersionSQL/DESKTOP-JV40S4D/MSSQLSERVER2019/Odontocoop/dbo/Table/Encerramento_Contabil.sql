/****** Object:  Table [dbo].[Encerramento_Contabil]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Encerramento_Contabil](
	[ecID] [int] IDENTITY(1,1) NOT NULL,
	[ecDt_cadastro] [datetime] NOT NULL,
	[ecCd_usuarioCadastro] [int] NOT NULL,
	[ecDt_Competencia] [datetime] NOT NULL,
 CONSTRAINT [PK_Encerramento_Contabil] PRIMARY KEY CLUSTERED 
(
	[ecID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
