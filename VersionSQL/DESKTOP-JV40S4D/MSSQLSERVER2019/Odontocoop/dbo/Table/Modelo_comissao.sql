/****** Object:  Table [dbo].[Modelo_comissao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Modelo_comissao](
	[cd_modelo] [int] IDENTITY(1,1) NOT NULL,
	[ds_modelo] [varchar](70) NULL,
 CONSTRAINT [PK_Modelo_comissao] PRIMARY KEY CLUSTERED 
(
	[cd_modelo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Modelo_comissao]  WITH CHECK ADD  CONSTRAINT [FK_Modelo_comissao_Modelo_comissao] FOREIGN KEY([cd_modelo])
REFERENCES [dbo].[Modelo_comissao] ([cd_modelo])
ALTER TABLE [dbo].[Modelo_comissao] CHECK CONSTRAINT [FK_Modelo_comissao_Modelo_comissao]
