/****** Object:  Table [dbo].[TelefoniaFilaRamal]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TelefoniaFilaRamal](
	[tfrId] [int] IDENTITY(1,1) NOT NULL,
	[tfiId] [int] NOT NULL,
	[traId] [int] NOT NULL,
	[tstId] [tinyint] NULL,
 CONSTRAINT [PK_TelefoniaFilaRamal] PRIMARY KEY CLUSTERED 
(
	[tfrId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TelefoniaFilaRamal]  WITH CHECK ADD  CONSTRAINT [FK_TelefoniaFilaRamal_TelefoniaFila] FOREIGN KEY([tfiId])
REFERENCES [dbo].[TelefoniaFila] ([tfiId])
ALTER TABLE [dbo].[TelefoniaFilaRamal] CHECK CONSTRAINT [FK_TelefoniaFilaRamal_TelefoniaFila]
ALTER TABLE [dbo].[TelefoniaFilaRamal]  WITH CHECK ADD  CONSTRAINT [FK_TelefoniaFilaRamal_TelefoniaRamal] FOREIGN KEY([traId])
REFERENCES [dbo].[TelefoniaRamal] ([traId])
ALTER TABLE [dbo].[TelefoniaFilaRamal] CHECK CONSTRAINT [FK_TelefoniaFilaRamal_TelefoniaRamal]
