/****** Object:  Table [dbo].[GrupoTratamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoTratamento](
	[idGrupoTratamento] [int] IDENTITY(1,1) NOT NULL,
	[nomeGrupoTratamento] [varchar](100) NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[usuarioAlteracao] [int] NULL,
	[dataAlteracao] [datetime] NULL,
	[usuarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
	[situacao] [bit] NULL,
 CONSTRAINT [PK_GrupoTratamento] PRIMARY KEY CLUSTERED 
(
	[idGrupoTratamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
