/****** Object:  Table [dbo].[BlackListContato]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BlackListContato](
	[cd_associado] [int] NOT NULL,
	[tblcId] [tinyint] NOT NULL,
	[cd_usuarioCadastro] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[BlackListContato]  WITH NOCHECK ADD  CONSTRAINT [FK_BlackListContato_ASSOCIADOS] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[BlackListContato] CHECK CONSTRAINT [FK_BlackListContato_ASSOCIADOS]
ALTER TABLE [dbo].[BlackListContato]  WITH NOCHECK ADD  CONSTRAINT [FK_BlackListContato_TipoBlackListContato] FOREIGN KEY([tblcId])
REFERENCES [dbo].[TipoBlackListContato] ([tblcId])
ALTER TABLE [dbo].[BlackListContato] CHECK CONSTRAINT [FK_BlackListContato_TipoBlackListContato]
