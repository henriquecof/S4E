/****** Object:  Table [dbo].[Padrao_Servico]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Padrao_Servico](
	[cd_padrao_servico] [smallint] NOT NULL,
	[ds_padrao_servico] [varchar](50) NULL,
 CONSTRAINT [PK_Padrao_Servico] PRIMARY KEY CLUSTERED 
(
	[cd_padrao_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
