/****** Object:  Table [dbo].[ArquivosCaixas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ArquivosCaixas](
	[arqCxId] [int] IDENTITY(1,1) NOT NULL,
	[Sequencial_Historico] [int] NOT NULL,
	[arqCxUsuExclusao] [int] NULL,
	[arqCxDtExclusao] [datetime] NULL,
	[arqCxNome] [varchar](300) NULL,
	[arqCxExtensao] [varchar](50) NULL,
	[arqCxUsuInclusao] [int] NULL,
	[arqCxDtInclusao] [datetime] NULL
) ON [PRIMARY]
