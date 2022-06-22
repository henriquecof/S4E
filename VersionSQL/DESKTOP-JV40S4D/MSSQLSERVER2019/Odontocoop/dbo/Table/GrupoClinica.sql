/****** Object:  Table [dbo].[GrupoClinica]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoClinica](
	[idGrupoClinica] [tinyint] NOT NULL,
	[descricaoGrupoClinica] [varchar](50) NOT NULL,
 CONSTRAINT [PK_GrupoClinica] PRIMARY KEY CLUSTERED 
(
	[idGrupoClinica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
