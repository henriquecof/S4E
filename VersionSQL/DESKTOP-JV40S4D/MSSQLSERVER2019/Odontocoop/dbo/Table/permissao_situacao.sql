/****** Object:  Table [dbo].[permissao_situacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[permissao_situacao](
	[cd_funcionario] [int] NOT NULL,
	[cd_situacao_historico] [smallint] NOT NULL,
 CONSTRAINT [PK_permissao_situacao] PRIMARY KEY NONCLUSTERED 
(
	[cd_funcionario] ASC,
	[cd_situacao_historico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[permissao_situacao]  WITH NOCHECK ADD  CONSTRAINT [FK_permissao_situacao_SITUACAO_HISTORICO] FOREIGN KEY([cd_situacao_historico])
REFERENCES [dbo].[SITUACAO_HISTORICO] ([CD_SITUACAO_HISTORICO])
ALTER TABLE [dbo].[permissao_situacao] CHECK CONSTRAINT [FK_permissao_situacao_SITUACAO_HISTORICO]
