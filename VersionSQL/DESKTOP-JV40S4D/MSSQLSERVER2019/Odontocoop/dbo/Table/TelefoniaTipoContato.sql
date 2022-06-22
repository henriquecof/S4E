/****** Object:  Table [dbo].[TelefoniaTipoContato]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TelefoniaTipoContato](
	[ttcId] [tinyint] NOT NULL,
	[ttcDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TelefoniaTipoContato] PRIMARY KEY CLUSTERED 
(
	[ttcId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
