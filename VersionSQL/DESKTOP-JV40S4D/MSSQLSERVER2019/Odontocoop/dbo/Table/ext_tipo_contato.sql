/****** Object:  Table [dbo].[ext_tipo_contato]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ext_tipo_contato](
	[id_ext_tipo_contato] [int] IDENTITY(1,1) NOT NULL,
	[tipo_contato] [varchar](45) NOT NULL,
 CONSTRAINT [ext_tipo_contato_1_3] PRIMARY KEY CLUSTERED 
(
	[id_ext_tipo_contato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
