/****** Object:  Table [dbo].[tiss_lote_Item_agrupado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tiss_lote_Item_agrupado](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_consultaPai] [int] NOT NULL,
	[cd_sequencial_consulta] [int] NOT NULL,
	[cd_sequencial_lote] [int] NOT NULL,
 CONSTRAINT [PK_tiss_lote_Item_agrupado] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[cd_sequencial_consultaPai] ASC,
	[cd_sequencial_consulta] ASC,
	[cd_sequencial_lote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tiss_lote_Item_agrupado]  WITH CHECK ADD  CONSTRAINT [FK_tiss_lote_Item_agrupado_Consultas] FOREIGN KEY([cd_sequencial_consultaPai])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[tiss_lote_Item_agrupado] CHECK CONSTRAINT [FK_tiss_lote_Item_agrupado_Consultas]
ALTER TABLE [dbo].[tiss_lote_Item_agrupado]  WITH CHECK ADD  CONSTRAINT [FK_tiss_lote_Item_agrupado_Consultas1] FOREIGN KEY([cd_sequencial_consulta])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[tiss_lote_Item_agrupado] CHECK CONSTRAINT [FK_tiss_lote_Item_agrupado_Consultas1]
ALTER TABLE [dbo].[tiss_lote_Item_agrupado]  WITH CHECK ADD  CONSTRAINT [FK_tiss_lote_Item_agrupado_TISS_lote] FOREIGN KEY([cd_sequencial_lote])
REFERENCES [dbo].[TISS_lote] ([cd_sequencial])
ALTER TABLE [dbo].[tiss_lote_Item_agrupado] CHECK CONSTRAINT [FK_tiss_lote_Item_agrupado_TISS_lote]
