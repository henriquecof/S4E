/****** Object:  Table [dbo].[PrioridadeConsultaCNS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PrioridadeConsultaCNS](
	[cd_sequencial_dep] [int] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[PrioridadeConsultaCNS]  WITH CHECK ADD FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
