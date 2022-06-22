/****** Object:  Table [dbo].[TelefoniaRamal]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TelefoniaRamal](
	[traId] [int] IDENTITY(1,1) NOT NULL,
	[traNumero] [varchar](4) NOT NULL,
	[traSIP] [varchar](50) NOT NULL,
	[traDtCadastro] [datetime] NOT NULL,
	[traDtExclusao] [datetime] NULL,
	[cd_funcionarioLogado] [int] NULL,
	[tstId] [tinyint] NULL,
 CONSTRAINT [PK_TelefoniaRamal] PRIMARY KEY CLUSTERED 
(
	[traId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TelefoniaRamal]  WITH CHECK ADD  CONSTRAINT [FK_TelefoniaRamal_TelefoniaStatus] FOREIGN KEY([tstId])
REFERENCES [dbo].[TelefoniaStatus] ([tstId])
ALTER TABLE [dbo].[TelefoniaRamal] CHECK CONSTRAINT [FK_TelefoniaRamal_TelefoniaStatus]
