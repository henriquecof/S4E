/****** Object:  Table [dbo].[Contabilidade]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Contabilidade](
	[cd_contabilidade] [int] IDENTITY(1,1) NOT NULL,
	[ds_contabilidade] [varchar](100) NOT NULL,
	[cd_tabela_contabilidade] [int] NULL,
	[cd_conta_contabil] [varchar](50) NULL,
 CONSTRAINT [PK_Contabilidade] PRIMARY KEY CLUSTERED 
(
	[cd_contabilidade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
