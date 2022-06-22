/****** Object:  Table [dbo].[Tabelas_Comissao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tabelas_Comissao](
	[cd_tabela_comissao] [int] IDENTITY(1,1) NOT NULL,
	[ds_tabela_comissao] [varchar](100) NULL,
 CONSTRAINT [PK_cd_tabela_comissao] PRIMARY KEY CLUSTERED 
(
	[cd_tabela_comissao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
