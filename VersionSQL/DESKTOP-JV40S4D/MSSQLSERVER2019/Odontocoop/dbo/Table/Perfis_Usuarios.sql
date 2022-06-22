/****** Object:  Table [dbo].[Perfis_Usuarios]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Perfis_Usuarios](
	[Cd_perfil] [int] NOT NULL,
	[ds_perfil] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Perfis_Usuarios] PRIMARY KEY CLUSTERED 
(
	[Cd_perfil] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
