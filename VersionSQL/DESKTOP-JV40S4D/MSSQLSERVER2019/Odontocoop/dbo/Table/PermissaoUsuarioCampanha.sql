/****** Object:  Table [dbo].[PermissaoUsuarioCampanha]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PermissaoUsuarioCampanha](
	[pucId] [int] IDENTITY(1,1) NOT NULL,
	[cd_campanha] [smallint] NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[dt_exclusao] [datetime] NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[cd_funcionarioExclusao] [int] NULL,
 CONSTRAINT [PK_PermissaoUsuarioCampanha] PRIMARY KEY CLUSTERED 
(
	[pucId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PermissaoUsuarioCampanha]  WITH CHECK ADD  CONSTRAINT [FK_PermissaoUsuarioCampanha_Campanha] FOREIGN KEY([cd_campanha])
REFERENCES [dbo].[Campanha] ([cd_campanha])
ALTER TABLE [dbo].[PermissaoUsuarioCampanha] CHECK CONSTRAINT [FK_PermissaoUsuarioCampanha_Campanha]
