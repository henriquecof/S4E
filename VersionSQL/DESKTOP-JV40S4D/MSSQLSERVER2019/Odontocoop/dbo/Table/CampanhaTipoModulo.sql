/****** Object:  Table [dbo].[CampanhaTipoModulo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CampanhaTipoModulo](
	[cd_campanha_tipo_modulo] [tinyint] NOT NULL,
	[descricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CampanhaTipoModulo] PRIMARY KEY CLUSTERED 
(
	[cd_campanha_tipo_modulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
