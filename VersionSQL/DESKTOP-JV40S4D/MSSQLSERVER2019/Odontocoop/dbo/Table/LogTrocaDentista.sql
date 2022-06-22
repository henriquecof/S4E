/****** Object:  Table [dbo].[LogTrocaDentista]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LogTrocaDentista](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_agenda] [int] NULL,
	[usuarioCadastro] [int] NULL,
	[dataCadastro] [datetime] NULL,
	[cd_funcionario_dentista_origem] [int] NULL,
	[cd_funcionario_dentista_destino] [int] NULL,
	[id_motivo] [int] NULL,
	[ds_motivo] [varchar](100) NULL,
	[dataMarcacaorigem] [datetime] NULL,
	[dataMarcacaoDestino] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LogTrocaDentista]  WITH CHECK ADD  CONSTRAINT [FK__LogTrocaD__cd_fu__24DE5343] FOREIGN KEY([cd_funcionario_dentista_origem])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[LogTrocaDentista] CHECK CONSTRAINT [FK__LogTrocaD__cd_fu__24DE5343]
ALTER TABLE [dbo].[LogTrocaDentista]  WITH CHECK ADD  CONSTRAINT [FK__LogTrocaD__cd_fu__25D2777C] FOREIGN KEY([cd_funcionario_dentista_destino])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[LogTrocaDentista] CHECK CONSTRAINT [FK__LogTrocaD__cd_fu__25D2777C]
ALTER TABLE [dbo].[LogTrocaDentista]  WITH CHECK ADD FOREIGN KEY([cd_sequencial_agenda])
REFERENCES [dbo].[agenda] ([cd_sequencial])
ALTER TABLE [dbo].[LogTrocaDentista]  WITH CHECK ADD  CONSTRAINT [FK__LogTrocaD__usuar__23EA2F0A] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[LogTrocaDentista] CHECK CONSTRAINT [FK__LogTrocaD__usuar__23EA2F0A]
