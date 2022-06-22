/****** Object:  Table [dbo].[Reajuste_Filial]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Reajuste_Filial](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_filial] [int] NOT NULL,
	[dt_reajuste] [datetime] NOT NULL,
	[cd_usuario] [int] NOT NULL,
	[perc_reajuste] [float] NOT NULL,
	[dt_aplicado_reajuste] [datetime] NULL,
	[dt_executado_reajuste] [datetime] NULL,
 CONSTRAINT [PK_Reajuste_Filial] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Reajuste_Filial]  WITH CHECK ADD  CONSTRAINT [FK_Reajuste_Filial_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[Reajuste_Filial] CHECK CONSTRAINT [FK_Reajuste_Filial_FILIAL]
