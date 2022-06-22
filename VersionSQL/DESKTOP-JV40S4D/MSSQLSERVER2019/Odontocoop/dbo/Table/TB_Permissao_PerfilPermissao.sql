/****** Object:  Table [dbo].[TB_Permissao_PerfilPermissao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Permissao_PerfilPermissao](
	[cd_perfilpermissao] [int] NOT NULL,
	[tpsId] [smallint] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_Permissao_PerfilPermissao]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Permissao_PerfilPermissao_TB_PerfilPermissao] FOREIGN KEY([cd_perfilpermissao])
REFERENCES [dbo].[TB_PerfilPermissao] ([cd_perfilpermissao])
ALTER TABLE [dbo].[TB_Permissao_PerfilPermissao] CHECK CONSTRAINT [FK_TB_Permissao_PerfilPermissao_TB_PerfilPermissao]
ALTER TABLE [dbo].[TB_Permissao_PerfilPermissao]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Permissao_PerfilPermissao_TipoPermissaoSistema] FOREIGN KEY([tpsId])
REFERENCES [dbo].[TipoPermissaoSistema] ([tpsId])
ALTER TABLE [dbo].[TB_Permissao_PerfilPermissao] CHECK CONSTRAINT [FK_TB_Permissao_PerfilPermissao_TipoPermissaoSistema]
