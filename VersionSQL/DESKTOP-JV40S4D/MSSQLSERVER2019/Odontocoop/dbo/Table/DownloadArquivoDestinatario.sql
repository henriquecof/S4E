/****** Object:  Table [dbo].[DownloadArquivoDestinatario]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DownloadArquivoDestinatario](
	[dadId] [int] IDENTITY(1,1) NOT NULL,
	[darId] [int] NULL,
	[dtdId] [tinyint] NULL,
	[cargos] [varchar](200) NULL,
 CONSTRAINT [PK_DownloadArquivoDestinatario] PRIMARY KEY CLUSTERED 
(
	[dadId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[DownloadArquivoDestinatario]  WITH CHECK ADD  CONSTRAINT [FK_DownloadArquivoDestinatario_DownloadArquivo] FOREIGN KEY([darId])
REFERENCES [dbo].[DownloadArquivo] ([darId])
ALTER TABLE [dbo].[DownloadArquivoDestinatario] CHECK CONSTRAINT [FK_DownloadArquivoDestinatario_DownloadArquivo]
ALTER TABLE [dbo].[DownloadArquivoDestinatario]  WITH CHECK ADD  CONSTRAINT [FK_DownloadArquivoDestinatario_DownloadTipoDestinatario1] FOREIGN KEY([dtdId])
REFERENCES [dbo].[DownloadTipoDestinatario] ([dtdId])
ALTER TABLE [dbo].[DownloadArquivoDestinatario] CHECK CONSTRAINT [FK_DownloadArquivoDestinatario_DownloadTipoDestinatario1]
