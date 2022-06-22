/****** Object:  Table [dbo].[AbrangenciaRegiao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AbrangenciaRegiao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idClassificacaoANS] [smallint] NULL,
	[idAbrangencia] [int] NULL,
	[idUf] [smallint] NULL,
	[idMunicipio] [int] NULL,
 CONSTRAINT [PK_AbrangenciaRegiao] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AbrangenciaRegiao]  WITH CHECK ADD  CONSTRAINT [FK_AbrangenciaRegiao_Abrangencia] FOREIGN KEY([idAbrangencia])
REFERENCES [dbo].[Abrangencia] ([cd_abrangencia])
ALTER TABLE [dbo].[AbrangenciaRegiao] CHECK CONSTRAINT [FK_AbrangenciaRegiao_Abrangencia]
ALTER TABLE [dbo].[AbrangenciaRegiao]  WITH CHECK ADD  CONSTRAINT [FK_AbrangenciaRegiao_CLASSIFICACAO_ANS] FOREIGN KEY([idClassificacaoANS])
REFERENCES [dbo].[CLASSIFICACAO_ANS] ([cd_classificacao])
ALTER TABLE [dbo].[AbrangenciaRegiao] CHECK CONSTRAINT [FK_AbrangenciaRegiao_CLASSIFICACAO_ANS]
ALTER TABLE [dbo].[AbrangenciaRegiao]  WITH CHECK ADD  CONSTRAINT [FK_AbrangenciaRegiao_MUNICIPIO] FOREIGN KEY([idMunicipio])
REFERENCES [dbo].[MUNICIPIO] ([CD_MUNICIPIO])
ALTER TABLE [dbo].[AbrangenciaRegiao] CHECK CONSTRAINT [FK_AbrangenciaRegiao_MUNICIPIO]
ALTER TABLE [dbo].[AbrangenciaRegiao]  WITH CHECK ADD  CONSTRAINT [FK_AbrangenciaRegiao_UF] FOREIGN KEY([idUf])
REFERENCES [dbo].[UF] ([ufId])
ALTER TABLE [dbo].[AbrangenciaRegiao] CHECK CONSTRAINT [FK_AbrangenciaRegiao_UF]
