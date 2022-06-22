/****** Object:  Table [dbo].[MensalidadesAcordo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MensalidadesAcordo](
	[cd_parcela] [int] NOT NULL,
	[acoId] [int] NOT NULL,
 CONSTRAINT [PK_Table_1_2] PRIMARY KEY CLUSTERED 
(
	[cd_parcela] ASC,
	[acoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MensalidadesAcordo]  WITH CHECK ADD  CONSTRAINT [FK_AcordoMensalidade] FOREIGN KEY([acoId])
REFERENCES [dbo].[Acordo] ([acoId])
ALTER TABLE [dbo].[MensalidadesAcordo] CHECK CONSTRAINT [FK_AcordoMensalidade]
ALTER TABLE [dbo].[MensalidadesAcordo]  WITH CHECK ADD  CONSTRAINT [FK_MensalidadeAcordo] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[MensalidadesAcordo] CHECK CONSTRAINT [FK_MensalidadeAcordo]
