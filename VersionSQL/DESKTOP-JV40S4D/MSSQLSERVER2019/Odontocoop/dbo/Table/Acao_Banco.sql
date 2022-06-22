/****** Object:  Table [dbo].[Acao_Banco]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Acao_Banco](
	[cd_acao_banco] [smallint] NOT NULL,
	[ds_acao_banco] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Acao_Banco] PRIMARY KEY CLUSTERED 
(
	[cd_acao_banco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
