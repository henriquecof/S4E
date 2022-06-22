/****** Object:  Table [dbo].[acerto_comissao_vendedor]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[acerto_comissao_vendedor](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tipo] [bit] NULL,
	[cd_sequencial_lote_comissao] [int] NULL,
	[cd_sequencial_dependente] [int] NULL,
	[motivo] [varchar](500) NULL,
	[usuario_cadastro] [int] NULL,
	[usuario_atualizacao] [int] NULL,
	[valor] [money] NULL,
	[data_exclusao] [datetime] NULL,
	[cd_funcionario_vendedor] [int] NULL,
	[data_cadastro] [datetime] NULL,
	[usuario_exclusao] [int] NULL,
	[data_realizado] [datetime] NULL,
	[usuario_realizacao] [int] NULL,
	[lancamentos] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[acerto_comissao_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_DEPENDENTES] FOREIGN KEY([cd_sequencial_dependente])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[acerto_comissao_vendedor] CHECK CONSTRAINT [FK_DEPENDENTES]
ALTER TABLE [dbo].[acerto_comissao_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_FUNCIONARIO_cd_funcionario_cd_funcionario_vendedor] FOREIGN KEY([cd_funcionario_vendedor])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[acerto_comissao_vendedor] CHECK CONSTRAINT [FK_FUNCIONARIO_cd_funcionario_cd_funcionario_vendedor]
ALTER TABLE [dbo].[acerto_comissao_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_FUNCIONARIO_cd_funcionario_usuario_atualizacao] FOREIGN KEY([usuario_atualizacao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[acerto_comissao_vendedor] CHECK CONSTRAINT [FK_FUNCIONARIO_cd_funcionario_usuario_atualizacao]
ALTER TABLE [dbo].[acerto_comissao_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_FUNCIONARIO_cd_funcionario_usuario_cadastro] FOREIGN KEY([usuario_cadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[acerto_comissao_vendedor] CHECK CONSTRAINT [FK_FUNCIONARIO_cd_funcionario_usuario_cadastro]
ALTER TABLE [dbo].[acerto_comissao_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_FUNCIONARIO_cd_funcionario_usuario_exclusao] FOREIGN KEY([usuario_exclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[acerto_comissao_vendedor] CHECK CONSTRAINT [FK_FUNCIONARIO_cd_funcionario_usuario_exclusao]
ALTER TABLE [dbo].[acerto_comissao_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_FUNCIONARIO_cd_funcionario_usuario_realizacao] FOREIGN KEY([usuario_realizacao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[acerto_comissao_vendedor] CHECK CONSTRAINT [FK_FUNCIONARIO_cd_funcionario_usuario_realizacao]
ALTER TABLE [dbo].[acerto_comissao_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_lote_comissao_cd_sequencial] FOREIGN KEY([cd_sequencial_lote_comissao])
REFERENCES [dbo].[lote_comissao] ([cd_sequencial])
ALTER TABLE [dbo].[acerto_comissao_vendedor] CHECK CONSTRAINT [FK_lote_comissao_cd_sequencial]
