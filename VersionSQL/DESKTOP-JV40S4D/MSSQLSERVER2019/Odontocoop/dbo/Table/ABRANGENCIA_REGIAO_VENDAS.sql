/****** Object:  Table [dbo].[ABRANGENCIA_REGIAO_VENDAS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ABRANGENCIA_REGIAO_VENDAS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ID_ABRANGENCIA] [int] NULL,
	[ID_ESTADO] [int] NULL,
	[ID_MUNICIPIO] [int] NULL
) ON [PRIMARY]
