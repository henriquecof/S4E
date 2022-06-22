/****** Object:  Table [dbo].[TISS_lote_item]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TISS_lote_item](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_lote] [int] NOT NULL,
	[cd_sequencial_consulta] [int] NOT NULL,
	[indicadorEnvioPapel] [bit] NOT NULL,
	[CNES] [varchar](7) NULL,
	[codigoCNPJ_CPF] [varchar](14) NULL,
	[municipioExecutante] [int] NULL,
	[municipioExecutante_ibge] [int] NULL,
	[numeroCartaoNacionalSaude] [varchar](50) NULL,
	[sexo] [varchar](1) NULL,
	[dataNascimento] [datetime] NULL,
	[municipioResidencia] [int] NULL,
	[municipioResidencia_ibge] [int] NULL,
	[numeroRegistroPlano] [varchar](20) NOT NULL,
	[origemEventoAtencao] [varchar](1) NULL,
	[numeroGuia_prestador] [varchar](20) NOT NULL,
	[numeroGuia_operadora] [varchar](20) NOT NULL,
	[identificacaoReembolso] [varchar](20) NULL,
	[dataSolicitacao] [datetime] NULL,
	[dataAutorizacao] [datetime] NULL,
	[dataRealizacao] [datetime] NOT NULL,
	[dataProtocoloCobranca] [datetime] NOT NULL,
	[dataPagamento] [datetime] NULL,
	[dataProcessamentoGuia] [datetime] NOT NULL,
	[tipoFaturamento] [varchar](1) NOT NULL,
	[declaracaoNascido] [varchar](11) NULL,
	[codigoProcedimento] [varchar](10) NOT NULL,
	[codDente] [varchar](2) NULL,
	[codRegiao] [varchar](4) NULL,
	[denteFace] [varchar](5) NULL,
	[valorInformado] [money] NOT NULL,
	[quantidadeInformada] [int] NOT NULL,
	[quantidadePaga] [int] NOT NULL,
	[valorPagoProc] [money] NOT NULL,
	[valorProcessado] [money] NOT NULL,
	[fl_erro] [bit] NULL,
	[mensagemErro] [varchar](1000) NULL,
	[valorTotalInformado] [money] NULL,
	[valorTotalProcessado] [nchar](10) NULL,
	[fl_desprezar] [bit] NULL,
	[idCampo] [int] NULL,
	[errCod] [int] NULL,
	[cd_grupoprocedimento] [int] NULL,
	[dataConhecimento] [date] NULL,
	[cboExecutante] [int] NULL,
	[cd_tabelaANS] [varchar](2) NULL,
	[sequenciaArquivo] [smallint] NULL,
 CONSTRAINT [PK_TISS_lote_item] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IDX_TISS_lote_item] ON [dbo].[TISS_lote_item]
(
	[cd_sequencial_lote] ASC,
	[cd_grupoprocedimento] ASC
)
INCLUDE([cd_sequencial],[indicadorEnvioPapel],[CNES],[codigoCNPJ_CPF],[municipioExecutante_ibge],[numeroCartaoNacionalSaude],[sexo],[dataNascimento],[municipioResidencia_ibge],[numeroRegistroPlano],[origemEventoAtencao],[numeroGuia_prestador],[numeroGuia_operadora],[identificacaoReembolso],[dataSolicitacao],[dataAutorizacao],[dataRealizacao],[dataProtocoloCobranca],[dataPagamento],[dataProcessamentoGuia],[tipoFaturamento],[declaracaoNascido],[codigoProcedimento],[codDente],[codRegiao],[denteFace],[valorInformado],[quantidadeInformada],[quantidadePaga],[valorPagoProc],[valorTotalInformado],[valorTotalProcessado]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TISS_lote_item]  WITH CHECK ADD  CONSTRAINT [FK_TISS_lote_item_ANS_CAMPOS_TISS] FOREIGN KEY([idCampo])
REFERENCES [dbo].[ANS_CAMPOS_TISS] ([idANS])
ALTER TABLE [dbo].[TISS_lote_item] CHECK CONSTRAINT [FK_TISS_lote_item_ANS_CAMPOS_TISS]
ALTER TABLE [dbo].[TISS_lote_item]  WITH CHECK ADD  CONSTRAINT [FK_TISS_lote_item_TISS_lote] FOREIGN KEY([cd_sequencial_lote])
REFERENCES [dbo].[TISS_lote] ([cd_sequencial])
ALTER TABLE [dbo].[TISS_lote_item] CHECK CONSTRAINT [FK_TISS_lote_item_TISS_lote]
