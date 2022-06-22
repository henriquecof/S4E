/****** Object:  Table [dbo].[TipoCarenciaAtendimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoCarenciaAtendimento](
	[tcaId] [smallint] NOT NULL,
	[tcaDescricao] [varchar](100) NOT NULL,
 CONSTRAINT [PK_TipoCarenciaAtendimento] PRIMARY KEY CLUSTERED 
(
	[tcaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
