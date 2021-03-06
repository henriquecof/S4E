/****** Object:  Table [dbo].[Lote_Processos_Impressao_Mensalidades]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_Processos_Impressao_Mensalidades](
	[cd_sequencial_lote] [int] NOT NULL,
	[cd_parcela] [int] NOT NULL,
	[cd_associado] [int] NULL,
	[nm_sacado] [varchar](100) NULL,
	[dt_vencimento] [date] NULL,
	[vl_parcela] [money] NOT NULL,
	[cd_retorno] [smallint] NULL,
	[cd_sequencial_retorno] [int] NULL,
	[mensagem] [varchar](100) NULL,
	[cd_tipo_arquivo_banco] [smallint] NULL,
	[cd_acao_banco] [smallint] NULL,
 CONSTRAINT [PK_Lote_Processos_Impressao_Mensalidades] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_lote] ASC,
	[cd_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Lote_Processos_Impressao_Mensalidades]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Processos_Impressao_Mensalidades_Acao_Banco] FOREIGN KEY([cd_acao_banco])
REFERENCES [dbo].[Acao_Banco] ([cd_acao_banco])
ALTER TABLE [dbo].[Lote_Processos_Impressao_Mensalidades] CHECK CONSTRAINT [FK_Lote_Processos_Impressao_Mensalidades_Acao_Banco]
ALTER TABLE [dbo].[Lote_Processos_Impressao_Mensalidades]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_Processos_Impressao_Mensalidades_Lote_Processos_Bancos] FOREIGN KEY([cd_sequencial_lote])
REFERENCES [dbo].[Lote_Processos_Bancos] ([cd_sequencial])
ALTER TABLE [dbo].[Lote_Processos_Impressao_Mensalidades] CHECK CONSTRAINT [FK_Lote_Processos_Impressao_Mensalidades_Lote_Processos_Bancos]
ALTER TABLE [dbo].[Lote_Processos_Impressao_Mensalidades]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_Processos_Impressao_Mensalidades_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[Lote_Processos_Impressao_Mensalidades] CHECK CONSTRAINT [FK_Lote_Processos_Impressao_Mensalidades_MENSALIDADES]
ALTER TABLE [dbo].[Lote_Processos_Impressao_Mensalidades]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Processos_Impressao_Mensalidades_Tipo_arquivo_banco] FOREIGN KEY([cd_tipo_arquivo_banco])
REFERENCES [dbo].[Tipo_arquivo_banco] ([cd_tipo_arquivo_banco])
ALTER TABLE [dbo].[Lote_Processos_Impressao_Mensalidades] CHECK CONSTRAINT [FK_Lote_Processos_Impressao_Mensalidades_Tipo_arquivo_banco]
