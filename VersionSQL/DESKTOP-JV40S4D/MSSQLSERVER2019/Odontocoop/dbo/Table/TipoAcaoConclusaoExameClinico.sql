/****** Object:  Table [dbo].[TipoAcaoConclusaoExameClinico]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoAcaoConclusaoExameClinico](
	[taeId] [tinyint] NOT NULL,
	[taeDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoAcaoConclusaoExameClinico] PRIMARY KEY CLUSTERED 
(
	[taeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
