/****** Object:  Table [dbo].[TipoMidia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoMidia](
	[tmiId] [tinyint] IDENTITY(1,1) NOT NULL,
	[tmiDescricao] [varchar](50) NOT NULL,
	[fl_ativo] [bit] NULL,
 CONSTRAINT [PK_TipoMidia] PRIMARY KEY CLUSTERED 
(
	[tmiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
