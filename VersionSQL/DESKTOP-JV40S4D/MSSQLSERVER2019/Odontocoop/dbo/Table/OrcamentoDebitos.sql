/****** Object:  Table [dbo].[OrcamentoDebitos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OrcamentoDebitos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_orcamento] [int] NULL,
	[valor] [money] NULL,
	[motivo] [varchar](60) NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[OrcamentoDebitos]  WITH CHECK ADD  CONSTRAINT [OrcamentoDebitos_orcamento_clinico] FOREIGN KEY([id_orcamento])
REFERENCES [dbo].[orcamento_clinico] ([cd_orcamento])
ALTER TABLE [dbo].[OrcamentoDebitos] CHECK CONSTRAINT [OrcamentoDebitos_orcamento_clinico]
