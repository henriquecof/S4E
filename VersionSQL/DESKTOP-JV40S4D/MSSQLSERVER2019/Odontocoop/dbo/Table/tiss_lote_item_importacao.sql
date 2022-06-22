/****** Object:  Table [dbo].[tiss_lote_item_importacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tiss_lote_item_importacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[chave] [varchar](50) NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[REGISTO_ANS] [varchar](50) NULL,
	[CNES] [varchar](50) NULL,
	[ID_IDENT] [varchar](50) NULL,
	[CPF_CNPJ] [varchar](50) NULL,
	[MUNIC_PREST] [varchar](50) NULL,
	[REG_ANS_OP_INTERMEDIARIA] [varchar](50) NULL,
	[TP_ATEND_OP_INTERMEDIARIA] [varchar](50) NULL,
	[CNS] [varchar](50) NULL,
	[SEXO_BENEF] [varchar](50) NULL,
	[DATA_NASC_BENEF] [varchar](50) NULL,
	[MUNICIPIO_BENEF] [varchar](50) NULL,
	[PLANO] [varchar](50) NULL,
	[TIPO_GUIA] [varchar](50) NULL,
	[ORIGEM] [varchar](50) NULL,
	[GUIA_PRESTADOR] [varchar](50) NULL,
	[GUIA_OPERADORA] [varchar](50) NULL,
	[NUM_REEMBOLSO] [varchar](50) NULL,
	[GUIA_SOLIC_INTERN] [varchar](50) NULL,
	[NUM_GUIA_PRINC_SPSADT_ODONT] [varchar](50) NULL,
	[DATA_REALIZACAO_PROCEDIMENTO] [varchar](50) NULL,
	[DATA_INICIO_FAT] [varchar](50) NULL,
	[DATA_FIM] [varchar](50) NULL,
	[DATA_PROC] [varchar](50) NULL,
	[CBO] [varchar](50) NULL,
	[DIAGNOSTICO_PRINCIPAL] [varchar](50) NULL,
	[DIAGNOSTICO_SECUNDARIO] [varchar](50) NULL,
	[DIAGNOSTICO_TERCEIRO] [varchar](50) NULL,
	[DIAGNOSTICO_QUARTO] [varchar](50) NULL,
	[TIPO_ATENDIMENTO] [varchar](50) NULL,
	[TIPO_FATURAMENTO] [varchar](50) NULL,
	[MOTIVO_ENCERRAMENTO] [varchar](50) NULL,
	[VALOR_INFORMADO_GUIA] [varchar](50) NULL,
	[VALOR_TOTAL_GLOSA] [varchar](50) NULL,
	[VALOR_TOTAL_PAGO] [varchar](50) NULL,
	[VALOR_TOTAL_FORNECEDOR] [varchar](50) NULL,
	[VL_TOTAL_TABELA_PROPRIA] [varchar](50) NULL,
	[VALOR_COOPARTICIPACAO] [varchar](50) NULL,
 CONSTRAINT [PK_tiss_lote_item_importacao] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tiss_lote_item_importacao]  WITH CHECK ADD  CONSTRAINT [FK_tiss_lote_item_importacao_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[tiss_lote_item_importacao] CHECK CONSTRAINT [FK_tiss_lote_item_importacao_FUNCIONARIO]
