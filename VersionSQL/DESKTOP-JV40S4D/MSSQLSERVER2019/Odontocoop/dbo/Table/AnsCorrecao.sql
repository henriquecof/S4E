/****** Object:  Table [dbo].[AnsCorrecao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AnsCorrecao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idOcorrencia] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[registroANS] [varchar](6) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[AnsCorrecao]  WITH CHECK ADD  CONSTRAINT [FK_AnsCorrecaoOcorrencia_id] FOREIGN KEY([idOcorrencia])
REFERENCES [dbo].[AnsCorrecaoOcorrencia] ([id])
ALTER TABLE [dbo].[AnsCorrecao] CHECK CONSTRAINT [FK_AnsCorrecaoOcorrencia_id]
ALTER TABLE [dbo].[AnsCorrecao]  WITH CHECK ADD  CONSTRAINT [FK_FUNCIONARIO_cd_funcionario] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[AnsCorrecao] CHECK CONSTRAINT [FK_FUNCIONARIO_cd_funcionario]
