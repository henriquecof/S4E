/****** Object:  Table [dbo].[Filial_QtdMinGratificacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Filial_QtdMinGratificacao](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_filial] [int] NOT NULL,
	[nr_qtdeMinGratificacao] [int] NULL,
	[vl_base] [money] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[Filial_QtdMinGratificacao]  WITH CHECK ADD  CONSTRAINT [FK_Filial_QtdMinGratificacao_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[Filial_QtdMinGratificacao] CHECK CONSTRAINT [FK_Filial_QtdMinGratificacao_FILIAL]
