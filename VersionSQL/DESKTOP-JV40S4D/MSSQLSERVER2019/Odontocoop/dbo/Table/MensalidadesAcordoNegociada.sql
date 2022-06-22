/****** Object:  Table [dbo].[MensalidadesAcordoNegociada]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MensalidadesAcordoNegociada](
	[cd_parcela] [int] NOT NULL,
	[acoId] [int] NOT NULL,
 CONSTRAINT [PK_AcordoNegociada] PRIMARY KEY CLUSTERED 
(
	[cd_parcela] ASC,
	[acoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MensalidadesAcordoNegociada]  WITH CHECK ADD  CONSTRAINT [FK_AcordoMensalidadeNegociada] FOREIGN KEY([acoId])
REFERENCES [dbo].[Acordo] ([acoId])
ALTER TABLE [dbo].[MensalidadesAcordoNegociada] CHECK CONSTRAINT [FK_AcordoMensalidadeNegociada]
ALTER TABLE [dbo].[MensalidadesAcordoNegociada]  WITH CHECK ADD  CONSTRAINT [FK_MensalidadeAcordoNegociada] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[MensalidadesAcordoNegociada] CHECK CONSTRAINT [FK_MensalidadeAcordoNegociada]
