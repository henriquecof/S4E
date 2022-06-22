/****** Object:  Table [dbo].[IndiceCompetencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IndiceCompetencia](
	[IndiceId] [int] NULL,
	[percentual] [decimal](18, 2) NULL,
	[CompetenciaId] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[IndiceCompetencia]  WITH CHECK ADD  CONSTRAINT [FK_ConferenciaIndice] FOREIGN KEY([CompetenciaId])
REFERENCES [dbo].[competencia] ([Id])
ALTER TABLE [dbo].[IndiceCompetencia] CHECK CONSTRAINT [FK_ConferenciaIndice]
ALTER TABLE [dbo].[IndiceCompetencia]  WITH CHECK ADD  CONSTRAINT [fk_indiceConferencia] FOREIGN KEY([IndiceId])
REFERENCES [dbo].[IndiceReajuste] ([id])
ALTER TABLE [dbo].[IndiceCompetencia] CHECK CONSTRAINT [fk_indiceConferencia]
