/****** Object:  Table [dbo].[CRMTipoSolicitante]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMTipoSolicitante](
	[tsoId] [smallint] NOT NULL,
	[tsoDescricao] [varchar](20) NOT NULL,
	[tsoAtivo] [bit] NOT NULL,
 CONSTRAINT [PK_TipoDestinatario] PRIMARY KEY CLUSTERED 
(
	[tsoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
