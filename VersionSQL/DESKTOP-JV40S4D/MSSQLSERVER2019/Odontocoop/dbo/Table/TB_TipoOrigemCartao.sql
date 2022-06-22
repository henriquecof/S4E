/****** Object:  Table [dbo].[TB_TipoOrigemCartao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_TipoOrigemCartao](
	[id_TipoOrigemCartao] [tinyint] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](50) NOT NULL,
	[enderecoTransacao] [varchar](100) NULL,
 CONSTRAINT [PK_TB_TipoOrigemCartao] PRIMARY KEY CLUSTERED 
(
	[id_TipoOrigemCartao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
