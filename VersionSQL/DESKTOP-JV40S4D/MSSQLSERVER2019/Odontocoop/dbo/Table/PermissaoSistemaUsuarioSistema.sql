/****** Object:  Table [dbo].[PermissaoSistemaUsuarioSistema]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PermissaoSistemaUsuarioSistema](
	[usiId] [int] NOT NULL,
	[tpsId] [smallint] NOT NULL,
 CONSTRAINT [PK_PermissaoSistemaUsuarioSistema] PRIMARY KEY CLUSTERED 
(
	[usiId] ASC,
	[tpsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PermissaoSistemaUsuarioSistema]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_PermissaoSistemaUsuarioSistema_TB_TipoPermissaoSistema] FOREIGN KEY([tpsId])
REFERENCES [dbo].[TipoPermissaoSistema] ([tpsId])
ALTER TABLE [dbo].[PermissaoSistemaUsuarioSistema] CHECK CONSTRAINT [FK_TB_PermissaoSistemaUsuarioSistema_TB_TipoPermissaoSistema]
