/****** Object:  Table [dbo].[ext_ocorrencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ext_ocorrencia](
	[id_ext_ocorrencia] [int] IDENTITY(1,1) NOT NULL,
	[id_ext_tipo_ocorrencia] [int] NOT NULL,
	[nome_associado] [varchar](100) NULL,
	[codigo_entidade] [int] NULL,
	[data_inclusao] [datetime] NULL,
	[data_vencimento] [datetime] NULL,
	[nome_entidade] [varchar](100) NULL,
	[contrato] [varchar](50) NULL,
	[registro_instituicao_financeira] [bit] NULL,
	[comprador_fiador_avalista] [smallint] NULL,
	[valor] [money] NULL,
	[cidade_associado] [varchar](100) NULL,
	[estado_associado] [varchar](2) NULL,
	[telefone] [varchar](15) NULL,
	[id_ext_dado] [int] NULL,
	[classe] [varchar](2) NULL,
	[horizonte] [int] NULL,
	[mesagem_interpretativa_score] [varchar](500) NULL,
	[mesagem_semaforo] [varchar](500) NULL,
	[score] [money] NULL,
	[probabilidade] [money] NULL,
	[tipo_cliente_score] [varchar](50) NULL,
	[cnae] [varchar](15) NULL,
 CONSTRAINT [PK_ext_ocorrencia] PRIMARY KEY CLUSTERED 
(
	[id_ext_ocorrencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ext_ocorrencia]  WITH CHECK ADD  CONSTRAINT [FK_ext_ocorrencia_ext_dado] FOREIGN KEY([id_ext_dado])
REFERENCES [dbo].[ext_dado] ([id_ext_dado])
ALTER TABLE [dbo].[ext_ocorrencia] CHECK CONSTRAINT [FK_ext_ocorrencia_ext_dado]
ALTER TABLE [dbo].[ext_ocorrencia]  WITH CHECK ADD  CONSTRAINT [FK_ext_ocorrencia_ext_tipo_ocorrencia] FOREIGN KEY([id_ext_tipo_ocorrencia])
REFERENCES [dbo].[ext_tipo_ocorrencia] ([id_ext_tipo_ocorrencia])
ALTER TABLE [dbo].[ext_ocorrencia] CHECK CONSTRAINT [FK_ext_ocorrencia_ext_tipo_ocorrencia]
