/****** Object:  Table [dbo].[TipoUsuarioSistema]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoUsuarioSistema](
	[tusId] [smallint] IDENTITY(1,1) NOT NULL,
	[tusDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoUsuarioSistema] PRIMARY KEY CLUSTERED 
(
	[tusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TipoUsuarioSistema]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_TipoUsuarioSistema_TB_TipoUsuarioSistema] FOREIGN KEY([tusId])
REFERENCES [dbo].[TipoUsuarioSistema] ([tusId])
ALTER TABLE [dbo].[TipoUsuarioSistema] CHECK CONSTRAINT [FK_TB_TipoUsuarioSistema_TB_TipoUsuarioSistema]
