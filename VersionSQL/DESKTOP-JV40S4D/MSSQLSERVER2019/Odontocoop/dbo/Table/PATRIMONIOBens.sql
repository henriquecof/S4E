/****** Object:  Table [dbo].[PATRIMONIOBens]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PATRIMONIOBens](
	[id_bem] [int] IDENTITY(1,1) NOT NULL,
	[descricao_bem] [varchar](200) NOT NULL,
	[marca] [varchar](100) NULL,
	[modelo] [varchar](100) NULL,
	[nr_serie] [varchar](20) NULL,
	[dimensao_altura] [money] NULL,
	[dimensao_comprimento] [money] NULL,
	[data_compra] [datetime] NOT NULL,
	[valor_compra] [money] NOT NULL,
	[nr_NF] [varchar](20) NULL,
	[data_fabricacao] [datetime] NULL,
	[data_garantia] [datetime] NULL,
	[perc_padrao_depreciacao] [money] NULL,
	[valor_depreciar] [money] NULL,
	[cpc_27_vida_util] [int] NULL,
	[valor_depreciar_cpc_27] [money] NULL,
	[valor_residual] [money] NULL,
	[nm_penhor] [varchar](100) NULL,
	[data_penhor] [datetime] NULL,
	[data_baixa_penhor] [datetime] NULL,
	[data_baixa_venda] [datetime] NULL,
	[ds_circunstancia] [varchar](50) NULL,
	[id_Classificacao] [int] NOT NULL,
	[id_especiePatrimonial] [int] NOT NULL,
	[id_Localizacao] [int] NOT NULL,
	[id_motivoBaixa] [int] NOT NULL,
	[id_tipoAquisicao] [int] NOT NULL,
	[id_tipoPatrimonio] [int] NOT NULL,
	[id_fornecedor] [int] NOT NULL,
 CONSTRAINT [PK_PATRIMONIOBens] PRIMARY KEY CLUSTERED 
(
	[id_bem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PATRIMONIOBens]  WITH CHECK ADD  CONSTRAINT [FK_PATRIMONIOBens_FORNECEDORES] FOREIGN KEY([id_fornecedor])
REFERENCES [dbo].[FORNECEDORES] ([CD_FORNECEDOR])
ALTER TABLE [dbo].[PATRIMONIOBens] CHECK CONSTRAINT [FK_PATRIMONIOBens_FORNECEDORES]
ALTER TABLE [dbo].[PATRIMONIOBens]  WITH CHECK ADD  CONSTRAINT [FK_PATRIMONIOBens_PATRIMONIOClassificacao] FOREIGN KEY([id_Classificacao])
REFERENCES [dbo].[PATRIMONIOClassificacao] ([id_Classificacao])
ALTER TABLE [dbo].[PATRIMONIOBens] CHECK CONSTRAINT [FK_PATRIMONIOBens_PATRIMONIOClassificacao]
ALTER TABLE [dbo].[PATRIMONIOBens]  WITH CHECK ADD  CONSTRAINT [FK_PATRIMONIOBens_PATRIMONIOEspeciePatrimonial] FOREIGN KEY([id_especiePatrimonial])
REFERENCES [dbo].[PATRIMONIOEspeciePatrimonial] ([id_especiePatrimonial])
ALTER TABLE [dbo].[PATRIMONIOBens] CHECK CONSTRAINT [FK_PATRIMONIOBens_PATRIMONIOEspeciePatrimonial]
ALTER TABLE [dbo].[PATRIMONIOBens]  WITH CHECK ADD  CONSTRAINT [FK_PATRIMONIOBens_PATRIMONIOLocalizacao] FOREIGN KEY([id_Localizacao])
REFERENCES [dbo].[PATRIMONIOLocalizacao] ([id_Localizacao])
ALTER TABLE [dbo].[PATRIMONIOBens] CHECK CONSTRAINT [FK_PATRIMONIOBens_PATRIMONIOLocalizacao]
ALTER TABLE [dbo].[PATRIMONIOBens]  WITH CHECK ADD  CONSTRAINT [FK_PATRIMONIOBens_PATRIMONIOMotivoBaixa] FOREIGN KEY([id_motivoBaixa])
REFERENCES [dbo].[PATRIMONIOMotivoBaixa] ([id_motivoBaixa])
ALTER TABLE [dbo].[PATRIMONIOBens] CHECK CONSTRAINT [FK_PATRIMONIOBens_PATRIMONIOMotivoBaixa]
ALTER TABLE [dbo].[PATRIMONIOBens]  WITH CHECK ADD  CONSTRAINT [FK_PATRIMONIOBens_PATRIMONIOTipoAquisicao] FOREIGN KEY([id_tipoAquisicao])
REFERENCES [dbo].[PATRIMONIOTipoAquisicao] ([id_tipoAquisicao])
ALTER TABLE [dbo].[PATRIMONIOBens] CHECK CONSTRAINT [FK_PATRIMONIOBens_PATRIMONIOTipoAquisicao]
ALTER TABLE [dbo].[PATRIMONIOBens]  WITH CHECK ADD  CONSTRAINT [FK_PATRIMONIOBens_PATRIMONIOTipoPatrimonio] FOREIGN KEY([id_tipoPatrimonio])
REFERENCES [dbo].[PATRIMONIOTipoPatrimonio] ([id_tipoPatrimonio])
ALTER TABLE [dbo].[PATRIMONIOBens] CHECK CONSTRAINT [FK_PATRIMONIOBens_PATRIMONIOTipoPatrimonio]
