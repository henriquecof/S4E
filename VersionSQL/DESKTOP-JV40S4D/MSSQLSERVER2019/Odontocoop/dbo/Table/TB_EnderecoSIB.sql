/****** Object:  Table [dbo].[TB_EnderecoSIB]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_EnderecoSIB](
	[cd_enderecoSIB] [tinyint] NOT NULL,
	[ds_enderecoSIB] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TB_EnderecoSIB] PRIMARY KEY CLUSTERED 
(
	[cd_enderecoSIB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
