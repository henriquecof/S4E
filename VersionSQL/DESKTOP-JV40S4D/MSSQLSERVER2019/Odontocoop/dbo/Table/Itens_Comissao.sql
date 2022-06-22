/****** Object:  Table [dbo].[Itens_Comissao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Itens_Comissao](
	[cd_ic] [int] IDENTITY(1,1) NOT NULL,
	[ic_ds_proposta] [nvarchar](255) NULL,
	[ic_primeira] [float] NULL,
	[ic_cd_tabela] [int] NULL,
	[ic_proposta] [int] NULL,
	[ic_nova] [float] NULL,
	[cd_modelo_comissao] [int] NULL,
 CONSTRAINT [PK_Itens_Comissao] PRIMARY KEY CLUSTERED 
(
	[cd_ic] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
