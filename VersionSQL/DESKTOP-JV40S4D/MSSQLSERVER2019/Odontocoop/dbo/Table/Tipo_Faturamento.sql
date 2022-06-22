/****** Object:  Table [dbo].[Tipo_Faturamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tipo_Faturamento](
	[cd_tipo_faturamento] [tinyint] NOT NULL,
	[nm_tipo_faturamento] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Tipo_Faturamento] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_faturamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
