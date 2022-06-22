/****** Object:  Table [dbo].[LoteCadastroDepartamentoItem]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LoteCadastroDepartamentoItem](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idLote] [int] NOT NULL,
	[sequenciaRegistro] [varchar](6) NULL,
	[nomeEmpresa] [varchar](40) NULL,
	[telefoneContato] [varchar](20) NULL,
	[nomeContato] [varchar](15) NULL,
	[numeroContrato] [varchar](12) NULL,
	[dataContrato] [varchar](8) NULL,
	[CNPJ_CPF_Empresa] [varchar](14) NULL,
	[inscricaoEstadual] [varchar](14) NULL,
	[tipoEmpresa] [varchar](1) NULL,
	[enderecoEmpresa] [varchar](40) NULL,
	[numeroEndereco] [varchar](5) NULL,
	[complementoEndereco] [varchar](15) NULL,
	[bairroEmpresa] [varchar](20) NULL,
	[cepEmpresa] [varchar](8) NULL,
	[cidadeEmpresa] [varchar](40) NULL,
	[ufEmpresa] [varchar](2) NULL,
	[codigoEmpresaCliente] [varchar](15) NULL,
	[tipoMovimentacao] [varchar](1) NULL,
	[dataTipoMovimentacao] [varchar](8) NULL,
	[situacaoFinanceira] [varchar](1) NULL,
	[operadoraRepasse] [varchar](2) NULL,
	[dataProcessamento] [datetime] NULL,
	[mensagemErro] [varchar](300) NULL,
	[dataInicial] [datetime] NULL,
	[dataFinal] [datetime] NULL,
 CONSTRAINT [PK_LoteCadastroDepartamentoItem] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[LoteCadastroDepartamentoItem]  WITH CHECK ADD  CONSTRAINT [FK_LoteCadastroDepartamentoItem_LoteCadastroDepartamento] FOREIGN KEY([idLote])
REFERENCES [dbo].[LoteCadastroDepartamento] ([id])
ALTER TABLE [dbo].[LoteCadastroDepartamentoItem] CHECK CONSTRAINT [FK_LoteCadastroDepartamentoItem_LoteCadastroDepartamento]
