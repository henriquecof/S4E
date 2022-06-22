/****** Object:  Table [dbo].[ABRANGENCIA_VENDAS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ABRANGENCIA_VENDAS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DESCRICAO] [varchar](100) NULL,
	[DATA_CADASTRO] [datetime] NULL,
	[CD_USUARIO] [int] NULL,
	[FL_ATIVO] [bit] NOT NULL
) ON [PRIMARY]
