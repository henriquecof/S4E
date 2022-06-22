/****** Object:  Table [dbo].[Parametro]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Parametro](
	[id] [int] NOT NULL,
	[nome] [varchar](100) NOT NULL,
	[descricao] [varchar](500) NOT NULL,
	[categoriaId] [int] NOT NULL,
	[tipoId] [int] NOT NULL,
 CONSTRAINT [PK_Parametro] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Parametro]  WITH CHECK ADD  CONSTRAINT [FK_Parametro_CategoriaParametro] FOREIGN KEY([categoriaId])
REFERENCES [dbo].[CategoriaParametro] ([id])
ALTER TABLE [dbo].[Parametro] CHECK CONSTRAINT [FK_Parametro_CategoriaParametro]
ALTER TABLE [dbo].[Parametro]  WITH CHECK ADD  CONSTRAINT [FK_Parametro_TipoParametro] FOREIGN KEY([tipoId])
REFERENCES [dbo].[TipoParametro] ([id])
ALTER TABLE [dbo].[Parametro] CHECK CONSTRAINT [FK_Parametro_TipoParametro]
