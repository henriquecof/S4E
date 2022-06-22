/****** Object:  Table [dbo].[InteracaoClinicoAgenda]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[InteracaoClinicoAgenda](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[sequencialDependente] [int] NOT NULL,
	[sequencialAgenda] [int] NOT NULL,
	[funcionarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[interacaoClinicoAgenda] [int] NOT NULL,
 CONSTRAINT [PK_InteracaoClinicoAgenda] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[InteracaoClinicoAgenda]  WITH CHECK ADD  CONSTRAINT [FK_InteracaoClinicoAgenda_agenda] FOREIGN KEY([sequencialAgenda])
REFERENCES [dbo].[agenda] ([cd_sequencial])
ALTER TABLE [dbo].[InteracaoClinicoAgenda] CHECK CONSTRAINT [FK_InteracaoClinicoAgenda_agenda]
ALTER TABLE [dbo].[InteracaoClinicoAgenda]  WITH CHECK ADD  CONSTRAINT [FK_InteracaoClinicoAgenda_DEPENDENTES] FOREIGN KEY([sequencialDependente])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[InteracaoClinicoAgenda] CHECK CONSTRAINT [FK_InteracaoClinicoAgenda_DEPENDENTES]
ALTER TABLE [dbo].[InteracaoClinicoAgenda]  WITH CHECK ADD  CONSTRAINT [FK_InteracaoClinicoAgenda_FUNCIONARIO] FOREIGN KEY([funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[InteracaoClinicoAgenda] CHECK CONSTRAINT [FK_InteracaoClinicoAgenda_FUNCIONARIO]
ALTER TABLE [dbo].[InteracaoClinicoAgenda]  WITH CHECK ADD  CONSTRAINT [FK_InteracaoClinicoAgenda_TipoInteracaoClinicoAgenda] FOREIGN KEY([interacaoClinicoAgenda])
REFERENCES [dbo].[TipoInteracaoClinicoAgenda] ([id])
ALTER TABLE [dbo].[InteracaoClinicoAgenda] CHECK CONSTRAINT [FK_InteracaoClinicoAgenda_TipoInteracaoClinicoAgenda]
