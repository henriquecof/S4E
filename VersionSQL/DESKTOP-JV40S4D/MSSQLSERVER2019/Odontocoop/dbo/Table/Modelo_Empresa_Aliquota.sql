/****** Object:  Table [dbo].[Modelo_Empresa_Aliquota]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Modelo_Empresa_Aliquota](
	[cd_tipo_empresa] [int] NOT NULL,
	[cd_centro_custo] [int] NOT NULL,
	[cd_aliquota] [smallint] NOT NULL,
	[id_retencao_aliquota] [tinyint] NULL,
 CONSTRAINT [PK_Modelo_Empresa_Aliquota] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_empresa] ASC,
	[cd_centro_custo] ASC,
	[cd_aliquota] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
