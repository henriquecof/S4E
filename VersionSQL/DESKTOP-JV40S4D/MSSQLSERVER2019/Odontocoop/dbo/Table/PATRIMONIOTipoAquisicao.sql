/****** Object:  Table [dbo].[PATRIMONIOTipoAquisicao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PATRIMONIOTipoAquisicao](
	[id_tipoAquisicao] [int] IDENTITY(1,1) NOT NULL,
	[descricao_tipoAquisicao] [varchar](200) NOT NULL,
 CONSTRAINT [PK_PATRIMONIOTipoAquisicao] PRIMARY KEY CLUSTERED 
(
	[id_tipoAquisicao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
