/****** Object:  Table [dbo].[tbSaidaEmail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tbSaidaEmail](
	[semId] [int] IDENTITY(1,1) NOT NULL,
	[semEmailRemetente] [varchar](100) NULL,
	[cd_origeminformacao] [int] NOT NULL,
	[codigo] [int] NOT NULL,
	[semEmail] [varchar](100) NOT NULL,
	[semAssunto] [varchar](500) NOT NULL,
	[semMensagem] [varchar](max) NOT NULL,
	[semChave] [varchar](100) NOT NULL,
	[semDtCadastro] [datetime] NOT NULL,
	[semDtEnvio] [datetime] NULL,
	[semDtVisualizacao] [datetime] NULL,
	[semDtExclusao] [datetime] NULL,
	[semIP] [varchar](50) NULL,
	[semTipoMensagem] [tinyint] NULL,
	[semPrioridadeMensagem] [tinyint] NULL,
	[semExcluirDuplicadoDia] [bit] NULL,
	[semAssinaturaMensagem] [bit] NULL,
	[mmeID] [int] NULL,
	[semAnexo] [varchar](300) NULL,
	[semMensagemConfidencial] [bit] NULL,
	[semTipoAcessoUsuario] [tinyint] NULL,
	[cd_parcela] [int] NULL,
	[semMsgError] [varchar](2000) NULL,
 CONSTRAINT [PK_SaidaEmail] PRIMARY KEY CLUSTERED 
(
	[semId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[tbSaidaEmail]  WITH CHECK ADD  CONSTRAINT [FK_tbSaidaEmail_MailingMensagem] FOREIGN KEY([mmeID])
REFERENCES [dbo].[MailingMensagem] ([mmeID])
ALTER TABLE [dbo].[tbSaidaEmail] CHECK CONSTRAINT [FK_tbSaidaEmail_MailingMensagem]
ALTER TABLE [dbo].[tbSaidaEmail]  WITH NOCHECK ADD  CONSTRAINT [FK_tbSaidaEmail_TB_OrigemInformacao] FOREIGN KEY([cd_origeminformacao])
REFERENCES [dbo].[TB_OrigemInformacao] ([cd_origeminformacao])
ALTER TABLE [dbo].[tbSaidaEmail] CHECK CONSTRAINT [FK_tbSaidaEmail_TB_OrigemInformacao]
