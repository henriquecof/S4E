/****** Object:  Table [dbo].[TB_ContaParametrizadas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ContaParametrizadas](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[dt_corte] [smallint] NOT NULL,
	[venc_inicial] [datetime] NOT NULL,
	[venc_final] [datetime] NOT NULL,
	[sequencial_movimentacao] [int] NOT NULL,
	[sequencial_conta] [int] NOT NULL,
	[historico] [varchar](200) NULL,
	[valor] [money] NOT NULL,
	[fl_carne] [bit] NULL,
	[nome_outros] [varchar](200) NULL,
	[cd_fornecedor] [int] NULL,
	[cd_funcionario] [int] NULL,
	[fl_ContasRecebidas] [tinyint] NULL,
	[competencia] [varchar](10) NULL,
	[iss] [money] NULL,
	[cofins] [money] NULL,
	[csll] [money] NULL,
	[ir] [money] NULL,
	[pis] [money] NULL,
	[valorTotal] [money] NULL,
	[dt_criacao] [datetime] NULL,
	[cd_UsuarioCadastro] [int] NULL,
 CONSTRAINT [PK_TB_ContaParametrizadas] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_ContaParametrizadas]  WITH CHECK ADD  CONSTRAINT [FK__TB_ContaP__cd_Us__37BC1D8D] FOREIGN KEY([cd_UsuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[TB_ContaParametrizadas] CHECK CONSTRAINT [FK__TB_ContaP__cd_Us__37BC1D8D]
ALTER TABLE [dbo].[TB_ContaParametrizadas]  WITH CHECK ADD  CONSTRAINT [FK__TB_ContaP__cd_Us__3A988A38] FOREIGN KEY([cd_UsuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[TB_ContaParametrizadas] CHECK CONSTRAINT [FK__TB_ContaP__cd_Us__3A988A38]
ALTER TABLE [dbo].[TB_ContaParametrizadas]  WITH CHECK ADD  CONSTRAINT [FK__TB_ContaP__cd_Us__6582E83D] FOREIGN KEY([cd_UsuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[TB_ContaParametrizadas] CHECK CONSTRAINT [FK__TB_ContaP__cd_Us__6582E83D]
ALTER TABLE [dbo].[TB_ContaParametrizadas]  WITH CHECK ADD  CONSTRAINT [FK_TB_ContaParametrizadas_Fornecedor] FOREIGN KEY([cd_fornecedor])
REFERENCES [dbo].[FORNECEDORES] ([CD_FORNECEDOR])
ALTER TABLE [dbo].[TB_ContaParametrizadas] CHECK CONSTRAINT [FK_TB_ContaParametrizadas_Fornecedor]
