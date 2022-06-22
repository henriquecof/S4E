/****** Object:  Table [dbo].[tipo_exportacao_contabilidade]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tipo_exportacao_contabilidade](
	[cd_tipo_exportacao_contabilidade] [smallint] NOT NULL,
	[ds_tipo_exportacao_contabilidade] [varchar](50) NULL,
 CONSTRAINT [PK_tipo_exportacao_contabilidade] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_exportacao_contabilidade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
