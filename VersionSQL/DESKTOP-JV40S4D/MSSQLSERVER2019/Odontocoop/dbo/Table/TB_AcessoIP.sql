/****** Object:  Table [dbo].[TB_AcessoIP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_AcessoIP](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao_acesso] [varchar](100) NOT NULL,
	[nr_ip] [varchar](15) NOT NULL,
	[nr_porta] [int] NULL,
	[data_cadastro] [datetime] NOT NULL,
	[usuario_cadastro] [int] NOT NULL,
	[fl_ativo] [bit] NOT NULL,
 CONSTRAINT [PK_TB_AcessoIP] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
