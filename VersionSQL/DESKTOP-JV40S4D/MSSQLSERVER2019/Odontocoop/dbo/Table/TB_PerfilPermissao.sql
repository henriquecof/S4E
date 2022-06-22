/****** Object:  Table [dbo].[TB_PerfilPermissao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_PerfilPermissao](
	[cd_perfilpermissao] [int] NOT NULL,
	[nm_perfil] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TB_PerfilPermissao] PRIMARY KEY CLUSTERED 
(
	[cd_perfilpermissao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
