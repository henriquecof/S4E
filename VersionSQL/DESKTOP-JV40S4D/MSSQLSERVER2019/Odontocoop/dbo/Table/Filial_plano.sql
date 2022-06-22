/****** Object:  Table [dbo].[Filial_plano]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Filial_plano](
	[cd_plano] [smallint] NOT NULL,
	[cd_filial] [int] NOT NULL,
 CONSTRAINT [PK_Filial_plano] PRIMARY KEY CLUSTERED 
(
	[cd_plano] ASC,
	[cd_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Filial_plano]  WITH CHECK ADD  CONSTRAINT [FK_Filial_plano_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[Filial_plano] CHECK CONSTRAINT [FK_Filial_plano_FILIAL]
