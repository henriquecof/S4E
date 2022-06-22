/****** Object:  Table [dbo].[Modelo_comissao_itens]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Modelo_comissao_itens](
	[cd_item] [int] IDENTITY(1,1) NOT NULL,
	[cd_modelo] [int] NOT NULL,
	[cd_parcela] [nvarchar](50) NOT NULL,
	[cd_tipocomissao] [smallint] NOT NULL,
	[percentual] [money] NOT NULL,
	[vendedor_reteu] [bit] NOT NULL,
 CONSTRAINT [PK_Modelo_comissao_itens_1] PRIMARY KEY CLUSTERED 
(
	[cd_modelo] ASC,
	[cd_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Modelo_comissao_itens]  WITH CHECK ADD  CONSTRAINT [FK_Modelo_comissao_itens_Modelo_comissao] FOREIGN KEY([cd_modelo])
REFERENCES [dbo].[Modelo_comissao] ([cd_modelo])
ALTER TABLE [dbo].[Modelo_comissao_itens] CHECK CONSTRAINT [FK_Modelo_comissao_itens_Modelo_comissao]
