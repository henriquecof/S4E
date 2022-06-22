/****** Object:  Table [dbo].[TabelaAdesaoContrato]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TabelaAdesaoContrato](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_plano] [int] NOT NULL,
	[minimoVidas] [int] NOT NULL,
	[maximoVidas] [int] NOT NULL,
	[valor] [money] NOT NULL,
 CONSTRAINT [PK__TabelaAd__3213E83F10383C18] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TabelaAdesaoContrato]  WITH CHECK ADD  CONSTRAINT [FK_PLANOS_cd_plano_TabelaAdesaoContrato] FOREIGN KEY([cd_plano])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[TabelaAdesaoContrato] CHECK CONSTRAINT [FK_PLANOS_cd_plano_TabelaAdesaoContrato]
