/****** Object:  Table [dbo].[PNL_PainelFila]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PNL_PainelFila](
	[cd_PainelFila] [int] IDENTITY(1,1) NOT NULL,
	[nm_PainelFila] [varchar](50) NOT NULL,
	[cd_TipoFila] [int] NOT NULL,
	[cd_painel] [int] NOT NULL,
	[fl_ativo] [bit] NOT NULL,
 CONSTRAINT [PK_PainelTipoFila] PRIMARY KEY CLUSTERED 
(
	[cd_PainelFila] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PNL_PainelFila]  WITH CHECK ADD  CONSTRAINT [FK_PNL_PainelFila_PNL_Painel] FOREIGN KEY([cd_painel])
REFERENCES [dbo].[PNL_Painel] ([cd_Painel])
ALTER TABLE [dbo].[PNL_PainelFila] CHECK CONSTRAINT [FK_PNL_PainelFila_PNL_Painel]
ALTER TABLE [dbo].[PNL_PainelFila]  WITH CHECK ADD  CONSTRAINT [FK_PNL_PainelFila_PNL_TipoFila] FOREIGN KEY([cd_TipoFila])
REFERENCES [dbo].[PNL_TipoFila] ([cd_TipoFila])
ALTER TABLE [dbo].[PNL_PainelFila] CHECK CONSTRAINT [FK_PNL_PainelFila_PNL_TipoFila]
