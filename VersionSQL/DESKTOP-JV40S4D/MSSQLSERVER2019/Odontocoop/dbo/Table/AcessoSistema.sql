/****** Object:  Table [dbo].[AcessoSistema]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AcessoSistema](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[usuario] [int] NULL,
	[tipoUsuario] [tinyint] NULL,
	[data] [datetime] NULL,
	[idAcessoSistemaTipoAcao] [tinyint] NULL,
	[url] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[AcessoSistema]  WITH CHECK ADD  CONSTRAINT [FK_AcessoSistemaTipoAcao_id] FOREIGN KEY([idAcessoSistemaTipoAcao])
REFERENCES [dbo].[AcessoSistemaTipoAcao] ([id])
ALTER TABLE [dbo].[AcessoSistema] CHECK CONSTRAINT [FK_AcessoSistemaTipoAcao_id]
ALTER TABLE [dbo].[AcessoSistema]  WITH CHECK ADD  CONSTRAINT [FK_TipoUsuario_tipo] FOREIGN KEY([tipoUsuario])
REFERENCES [dbo].[TipoUsuario] ([tipo])
ALTER TABLE [dbo].[AcessoSistema] CHECK CONSTRAINT [FK_TipoUsuario_tipo]
