/****** Object:  Table [dbo].[TB_TipoContato]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_TipoContato](
	[tteSequencial] [smallint] NOT NULL,
	[tteDescricao] [varchar](30) NOT NULL,
	[fl_ativo] [bit] NULL,
	[dominio_TipoTelefone] [smallint] NULL,
 CONSTRAINT [PK_TB_TipoTelefone] PRIMARY KEY CLUSTERED 
(
	[tteSequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
