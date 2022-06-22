/****** Object:  Table [dbo].[TipoSistema]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoSistema](
	[tsiId] [tinyint] IDENTITY(1,1) NOT NULL,
	[tsiDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoSistema] PRIMARY KEY CLUSTERED 
(
	[tsiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
