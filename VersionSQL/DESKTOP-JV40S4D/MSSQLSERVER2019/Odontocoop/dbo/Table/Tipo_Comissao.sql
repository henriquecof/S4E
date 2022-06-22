/****** Object:  Table [dbo].[Tipo_Comissao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tipo_Comissao](
	[cd_tipo_comissao] [smallint] NOT NULL,
	[nm_tipo_comissao] [varchar](50) NOT NULL,
	[fl_ativo] [bit] NULL,
	[observacao] [varchar](500) NULL,
 CONSTRAINT [PK_Tipo_Comissao] PRIMARY KEY NONCLUSTERED 
(
	[cd_tipo_comissao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
