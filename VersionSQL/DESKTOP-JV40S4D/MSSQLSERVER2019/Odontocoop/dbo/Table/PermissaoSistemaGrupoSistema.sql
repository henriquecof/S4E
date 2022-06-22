/****** Object:  Table [dbo].[PermissaoSistemaGrupoSistema]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PermissaoSistemaGrupoSistema](
	[gfuId] [int] NOT NULL,
	[tpsId] [smallint] NOT NULL,
 CONSTRAINT [PK_PermissaoSistemaGrupoSistema] PRIMARY KEY CLUSTERED 
(
	[gfuId] ASC,
	[tpsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PermissaoSistemaGrupoSistema]  WITH NOCHECK ADD  CONSTRAINT [FK_PermissaoSistemaGrupoSistema_GrupoFuncionario] FOREIGN KEY([gfuId])
REFERENCES [dbo].[GrupoFuncionario] ([gfuId])
ALTER TABLE [dbo].[PermissaoSistemaGrupoSistema] CHECK CONSTRAINT [FK_PermissaoSistemaGrupoSistema_GrupoFuncionario]
ALTER TABLE [dbo].[PermissaoSistemaGrupoSistema]  WITH NOCHECK ADD  CONSTRAINT [FK_PermissaoSistemaGrupoSistema_TipoPermissaoSistema] FOREIGN KEY([tpsId])
REFERENCES [dbo].[TipoPermissaoSistema] ([tpsId])
ALTER TABLE [dbo].[PermissaoSistemaGrupoSistema] CHECK CONSTRAINT [FK_PermissaoSistemaGrupoSistema_TipoPermissaoSistema]
