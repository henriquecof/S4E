/****** Object:  Table [dbo].[TipoEstabelecimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoEstabelecimento](
	[tesId] [tinyint] IDENTITY(1,1) NOT NULL,
	[tesDescricao] [varchar](50) NULL
) ON [PRIMARY]
