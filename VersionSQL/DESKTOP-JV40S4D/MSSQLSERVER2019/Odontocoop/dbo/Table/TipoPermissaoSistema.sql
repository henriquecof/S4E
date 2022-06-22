/****** Object:  Table [dbo].[TipoPermissaoSistema]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoPermissaoSistema](
	[tpsId] [smallint] NOT NULL,
	[tpsDescricao] [varchar](100) NOT NULL,
	[url_pagina] [varchar](200) NULL,
	[url_icone] [varchar](100) NULL,
	[nm_descricao] [varchar](500) NULL,
	[fl_ativo] [bit] NULL,
	[pmId] [tinyint] NULL,
	[nm_endereco_caminho] [varchar](300) NULL,
 CONSTRAINT [PK_TipoPermissaoSistema] PRIMARY KEY CLUSTERED 
(
	[tpsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TipoPermissaoSistema]  WITH NOCHECK ADD  CONSTRAINT [FK_TipoPermissaoSistema_PermissaoMenu] FOREIGN KEY([pmId])
REFERENCES [dbo].[PermissaoMenu] ([pmId])
ALTER TABLE [dbo].[TipoPermissaoSistema] CHECK CONSTRAINT [FK_TipoPermissaoSistema_PermissaoMenu]
