/****** Object:  Table [dbo].[TelefoniaTipoRetorno]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TelefoniaTipoRetorno](
	[ttrId] [tinyint] NOT NULL,
	[ttrCodigo] [varchar](50) NOT NULL,
	[ttrDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TelefoniaTipoRetorno] PRIMARY KEY CLUSTERED 
(
	[ttrId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
