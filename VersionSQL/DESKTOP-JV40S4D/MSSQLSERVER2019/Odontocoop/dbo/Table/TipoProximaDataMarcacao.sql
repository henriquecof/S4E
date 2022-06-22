/****** Object:  Table [dbo].[TipoProximaDataMarcacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoProximaDataMarcacao](
	[tpmId] [tinyint] NOT NULL,
	[tpmDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoProximaDataMarcacao] PRIMARY KEY CLUSTERED 
(
	[tpmId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
