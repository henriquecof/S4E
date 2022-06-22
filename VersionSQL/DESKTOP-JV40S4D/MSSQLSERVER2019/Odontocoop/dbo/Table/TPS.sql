/****** Object:  Table [dbo].[TPS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TPS](
	[cd_id] [int] IDENTITY(1,1) NOT NULL,
	[competencia] [varchar](50) NOT NULL,
	[qtde_menor_60] [int] NOT NULL,
	[qtde_maior_60] [int] NOT NULL,
	[total] [int] NOT NULL,
	[cd_abrangencia] [int] NULL,
	[ds_abrangencia] [varchar](50) NULL,
 CONSTRAINT [PK_TPS] PRIMARY KEY CLUSTERED 
(
	[cd_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
