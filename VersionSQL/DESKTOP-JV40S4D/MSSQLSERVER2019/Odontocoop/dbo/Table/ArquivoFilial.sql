/****** Object:  Table [dbo].[ArquivoFilial]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ArquivoFilial](
	[afiId] [int] IDENTITY(1,1) NOT NULL,
	[cd_filial] [int] NOT NULL,
	[CD_UsuarioInclusao] [int] NULL,
	[afiDtInclusao] [datetime] NULL,
	[CD_UsuarioExclusao] [int] NULL,
	[afiDtExclusao] [datetime] NULL,
	[afiNome] [varchar](50) NOT NULL,
	[afiExtensao] [varchar](5) NOT NULL,
	[estaAprovado] [bit] NULL,
	[idUsuarioAprovacao] [int] NULL,
	[dataAprovacao] [datetime] NULL,
	[idAssuntoUpload] [int] NULL,
 CONSTRAINT [PK_ArquivoFilial] PRIMARY KEY CLUSTERED 
(
	[afiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ArquivoFilial]  WITH CHECK ADD  CONSTRAINT [FK_ArquivoFilial] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[ArquivoFilial] CHECK CONSTRAINT [FK_ArquivoFilial]
ALTER TABLE [dbo].[ArquivoFilial]  WITH CHECK ADD  CONSTRAINT [FK_ArquivoFilial_AssuntosUpload] FOREIGN KEY([idAssuntoUpload])
REFERENCES [dbo].[AssuntosUpload] ([id])
ALTER TABLE [dbo].[ArquivoFilial] CHECK CONSTRAINT [FK_ArquivoFilial_AssuntosUpload]
