/****** Object:  Table [dbo].[Lote_EtqPostal]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_EtqPostal](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_lote] [int] NOT NULL,
	[cd_empresa] [int] NULL,
	[cd_associado] [int] NULL,
	[cd_dependente] [int] NULL,
	[cd_usuariocadastro] [int] NOT NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[dt_finalizado] [datetime] NULL,
	[cd_ordem] [int] NULL,
	[cd_funcionario] [int] NULL,
	[cd_filial] [int] NULL,
	[numero_dente] [int] NULL,
	[data] [datetime] NULL,
	[ecoId] [int] NULL,
 CONSTRAINT [PK_Lote_EtqPostal] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Lote_EtqPostal]  WITH CHECK ADD  CONSTRAINT [FK_Lote_EtqPostal_ASSOCIADOS] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[Lote_EtqPostal] CHECK CONSTRAINT [FK_Lote_EtqPostal_ASSOCIADOS]
ALTER TABLE [dbo].[Lote_EtqPostal]  WITH CHECK ADD  CONSTRAINT [FK_Lote_EtqPostal_DEPENDENTES] FOREIGN KEY([cd_dependente])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[Lote_EtqPostal] CHECK CONSTRAINT [FK_Lote_EtqPostal_DEPENDENTES]
ALTER TABLE [dbo].[Lote_EtqPostal]  WITH CHECK ADD  CONSTRAINT [FK_Lote_EtqPostal_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[Lote_EtqPostal] CHECK CONSTRAINT [FK_Lote_EtqPostal_FILIAL]
