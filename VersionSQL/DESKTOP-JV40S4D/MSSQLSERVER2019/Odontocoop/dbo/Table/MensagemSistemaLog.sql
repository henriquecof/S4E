/****** Object:  Table [dbo].[MensagemSistemaLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MensagemSistemaLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dataCadastro] [datetime] NULL,
	[codigo] [varchar](5) NULL,
	[mensagem] [varchar](500) NULL,
	[cd_filial] [int] NULL,
	[cd_funcionario] [int] NULL,
	[cd_dependente] [int] NULL,
	[usuario] [int] NULL,
	[tipoUsuario] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MensagemSistemaLog]  WITH CHECK ADD  CONSTRAINT [fk_AutErro_Dependentes] FOREIGN KEY([cd_dependente])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[MensagemSistemaLog] CHECK CONSTRAINT [fk_AutErro_Dependentes]
ALTER TABLE [dbo].[MensagemSistemaLog]  WITH CHECK ADD  CONSTRAINT [fk_AutErro_Filial] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[MensagemSistemaLog] CHECK CONSTRAINT [fk_AutErro_Filial]
