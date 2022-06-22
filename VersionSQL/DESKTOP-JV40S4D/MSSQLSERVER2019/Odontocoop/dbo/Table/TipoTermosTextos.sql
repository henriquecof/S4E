/****** Object:  Table [dbo].[TipoTermosTextos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoTermosTextos](
	[cd_tipo_termo_texto] [tinyint] NOT NULL,
	[ds_tipo_termo_texto] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoTermosTextos] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_termo_texto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
