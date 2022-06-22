/****** Object:  Table [dbo].[GrupoDocumentacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoDocumentacao](
	[idGrupo] [int] IDENTITY(1,1) NOT NULL,
	[descricaoGrupo] [varchar](100) NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[usuarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[idGrupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
