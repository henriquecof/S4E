/****** Object:  Table [dbo].[MotivoGlosaDetalhado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MotivoGlosaDetalhado](
	[idMotivoGlosaDetalhado] [int] NOT NULL,
	[nomeMotivoGlosaDetalhado] [varchar](200) NOT NULL,
	[ativo] [bit] NOT NULL,
 CONSTRAINT [PK__MotivoGl__BC8C3846031E381C] PRIMARY KEY CLUSTERED 
(
	[idMotivoGlosaDetalhado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
