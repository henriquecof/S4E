/****** Object:  Table [dbo].[GrupoAliquota]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoAliquota](
	[cd_grupo_aliquota] [tinyint] NOT NULL,
	[ds_grupo_aliquota] [varchar](50) NOT NULL,
 CONSTRAINT [PK_GrupoAliquota] PRIMARY KEY CLUSTERED 
(
	[cd_grupo_aliquota] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
