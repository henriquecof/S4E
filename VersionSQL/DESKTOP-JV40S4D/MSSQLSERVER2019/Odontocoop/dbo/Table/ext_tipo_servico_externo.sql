/****** Object:  Table [dbo].[ext_tipo_servico_externo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ext_tipo_servico_externo](
	[id_tipo_servico_externo] [int] NOT NULL,
	[tipo_servico_externo] [nchar](50) NULL,
 CONSTRAINT [PK_ext_tipo_servico_externo] PRIMARY KEY CLUSTERED 
(
	[id_tipo_servico_externo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
