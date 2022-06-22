/****** Object:  Table [dbo].[modelo_biometria]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[modelo_biometria](
	[cd_modelo_Biometria] [smallint] NOT NULL,
	[ds_modelo_biometria] [varchar](100) NOT NULL,
 CONSTRAINT [PK_modelo_biometria] PRIMARY KEY CLUSTERED 
(
	[cd_modelo_Biometria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
