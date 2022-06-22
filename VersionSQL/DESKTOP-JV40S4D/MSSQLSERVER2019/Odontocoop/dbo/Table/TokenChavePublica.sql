/****** Object:  Table [dbo].[TokenChavePublica]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TokenChavePublica](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idTokenTipoSistema] [int] NOT NULL,
	[chave] [uniqueidentifier] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
 CONSTRAINT [PK_TokenChavePublica] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TokenChavePublica]  WITH CHECK ADD  CONSTRAINT [FK_TokenChavePublica_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[TokenChavePublica] CHECK CONSTRAINT [FK_TokenChavePublica_FUNCIONARIO]
ALTER TABLE [dbo].[TokenChavePublica]  WITH CHECK ADD  CONSTRAINT [FK_TokenChavePublica_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[TokenChavePublica] CHECK CONSTRAINT [FK_TokenChavePublica_FUNCIONARIO1]
ALTER TABLE [dbo].[TokenChavePublica]  WITH CHECK ADD  CONSTRAINT [FK_TokenChavePublica_TokenTipoSistema] FOREIGN KEY([idTokenTipoSistema])
REFERENCES [dbo].[TokenTipoSistema] ([id])
ALTER TABLE [dbo].[TokenChavePublica] CHECK CONSTRAINT [FK_TokenChavePublica_TokenTipoSistema]
