﻿/****** Object:  Table [dbo].[MUNICIPIO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MUNICIPIO](
	[CD_MUNICIPIO] [int] IDENTITY(1,1) NOT NULL,
	[NM_MUNICIPIO] [nvarchar](120) NOT NULL,
	[CD_UF_num] [smallint] NULL,
	[CEP] [int] NULL,
	[cd_mun_ibge] [int] NULL,
	[fl_bairro] [bit] NULL,
	[id_regiao] [int] NULL,
	[cd_centro_custo] [smallint] NULL,
	[discarDDDTelefonia] [bit] NULL,
	[codigoSIAFI] [varchar](4) NULL,
	[exigeRegiaoCep] [bit] NULL,
	[codigoSEDETEC] [int] NULL,
 CONSTRAINT [PK_MUNICIPIO] PRIMARY KEY CLUSTERED 
(
	[CD_MUNICIPIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_MUNICIPIO] ON [dbo].[MUNICIPIO]
(
	[CD_UF_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_MUNICIPIO_2] ON [dbo].[MUNICIPIO]
(
	[CEP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[MUNICIPIO]  WITH CHECK ADD  CONSTRAINT [FK_MUNICIPIO_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[MUNICIPIO] CHECK CONSTRAINT [FK_MUNICIPIO_Centro_Custo]
ALTER TABLE [dbo].[MUNICIPIO]  WITH CHECK ADD  CONSTRAINT [FK_MUNICIPIO_Regiao] FOREIGN KEY([id_regiao])
REFERENCES [dbo].[Regiao] ([id_regiao])
ALTER TABLE [dbo].[MUNICIPIO] CHECK CONSTRAINT [FK_MUNICIPIO_Regiao]
ALTER TABLE [dbo].[MUNICIPIO]  WITH NOCHECK ADD  CONSTRAINT [FK_MUNICIPIO_UF] FOREIGN KEY([CD_UF_num])
REFERENCES [dbo].[UF] ([ufId])
ALTER TABLE [dbo].[MUNICIPIO] CHECK CONSTRAINT [FK_MUNICIPIO_UF]