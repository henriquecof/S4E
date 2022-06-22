/****** Object:  Table [dbo].[TIPO_EMPRESA]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TIPO_EMPRESA](
	[tp_empresa] [smallint] NOT NULL,
	[ds_empresa] [varchar](50) NOT NULL,
	[cd_classificacao] [smallint] NULL,
	[nm_sigla] [varchar](10) NULL,
 CONSTRAINT [PK_TIPO_EMPRESA] PRIMARY KEY NONCLUSTERED 
(
	[tp_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
