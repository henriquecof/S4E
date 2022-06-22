/****** Object:  Table [dbo].[Log_DeclaracaoIR]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Log_DeclaracaoIR](
	[cd_funcionario] [int] NULL,
	[data_doc] [datetime] NOT NULL,
	[cd_associado] [int] NOT NULL,
	[cd_filial] [int] NULL,
	[ano_referencia] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[Log_DeclaracaoIR]  WITH NOCHECK ADD  CONSTRAINT [FK_Log_DeclaracaoIR_ASSOCIADOS] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[Log_DeclaracaoIR] CHECK CONSTRAINT [FK_Log_DeclaracaoIR_ASSOCIADOS]
ALTER TABLE [dbo].[Log_DeclaracaoIR]  WITH NOCHECK ADD  CONSTRAINT [FK_Log_DeclaracaoIR_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[Log_DeclaracaoIR] CHECK CONSTRAINT [FK_Log_DeclaracaoIR_FILIAL]
