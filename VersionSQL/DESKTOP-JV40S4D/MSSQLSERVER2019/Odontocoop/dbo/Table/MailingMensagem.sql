/****** Object:  Table [dbo].[MailingMensagem]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MailingMensagem](
	[mmeID] [int] IDENTITY(1,1) NOT NULL,
	[mmeAssunto] [varchar](200) NOT NULL,
	[mmeDescricao] [varchar](max) NOT NULL,
	[mmeChave] [varchar](100) NOT NULL,
	[UsuarioCadastro] [int] NOT NULL,
	[mmeDtCadastro] [datetime] NOT NULL,
	[UsuarioExclusao] [int] NULL,
	[mmeDtExclusao] [datetime] NULL,
 CONSTRAINT [PK_MailingMensagem] PRIMARY KEY CLUSTERED 
(
	[mmeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[MailingMensagem]  WITH CHECK ADD  CONSTRAINT [FK_MailingMensagem_FUNCIONARIO] FOREIGN KEY([UsuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[MailingMensagem] CHECK CONSTRAINT [FK_MailingMensagem_FUNCIONARIO]
ALTER TABLE [dbo].[MailingMensagem]  WITH CHECK ADD  CONSTRAINT [FK_MailingMensagem_FUNCIONARIO1] FOREIGN KEY([UsuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[MailingMensagem] CHECK CONSTRAINT [FK_MailingMensagem_FUNCIONARIO1]
