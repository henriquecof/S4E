/****** Object:  Table [dbo].[DownloadTipoDestinatario]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DownloadTipoDestinatario](
	[dtdId] [tinyint] NOT NULL,
	[dtdDescricao] [varchar](20) NULL,
 CONSTRAINT [PK_DownloadTipoDestinatario] PRIMARY KEY CLUSTERED 
(
	[dtdId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
