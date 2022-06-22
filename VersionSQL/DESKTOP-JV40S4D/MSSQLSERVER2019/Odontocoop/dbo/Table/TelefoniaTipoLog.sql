/****** Object:  Table [dbo].[TelefoniaTipoLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TelefoniaTipoLog](
	[ttlId] [tinyint] NOT NULL,
	[ttlDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TelefoniaTipoLog] PRIMARY KEY CLUSTERED 
(
	[ttlId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
