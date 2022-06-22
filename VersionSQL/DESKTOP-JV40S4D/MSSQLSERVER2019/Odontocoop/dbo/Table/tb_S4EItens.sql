/****** Object:  Table [dbo].[tb_S4EItens]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tb_S4EItens](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[cd_campanha] [smallint] NOT NULL,
	[ID_ERP_CRM] [bigint] NULL,
	[Nome_Prospect] [varchar](1000) NOT NULL,
	[DtNascimento] [datetime] NULL,
	[CPF_CNPJ] [varchar](14) NULL,
	[RG_CGF] [varchar](200) NULL,
	[email] [varchar](1000) NULL,
	[sexo] [smallint] NULL,
	[Logradouro] [varchar](1000) NULL,
	[Complemento] [varchar](500) NULL,
	[Bairro] [varchar](1000) NULL,
	[cep] [varchar](8) NULL,
	[cidade] [varchar](1000) NULL,
	[estado] [varchar](2) NULL,
	[Data_ERP_CRM] [datetime] NULL,
	[Telefone_Contato_1] [varchar](100) NULL,
	[Telefone_Contato_2] [varchar](100) NULL,
	[Telefone_Contato_3] [varchar](100) NULL,
	[Contato_1] [varchar](1000) NULL,
	[Numero_Titulo] [varchar](1000) NOT NULL,
	[Tipo_Titulo] [varchar](1000) NOT NULL,
	[Data_Titulo] [datetime] NOT NULL,
	[Valor_Titulo] [money] NOT NULL,
	[Produto] [varchar](1000) NULL,
	[Filial] [varchar](1000) NULL,
	[Dia_Vencimento] [smallint] NULL,
	[Informacao_Adicional_1] [varchar](1000) NULL,
	[Informacao_Adicional_2] [varchar](1000) NULL,
	[Informacao_Adicional_3] [varchar](1000) NULL,
	[Auxiliar_1] [varchar](1000) NULL,
	[Auxiliar_2] [varchar](1000) NULL,
	[Auxiliar_3] [varchar](1000) NULL,
	[Agrupador] [int] NULL,
 CONSTRAINT [tb_S4E] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tb_S4EItens]  WITH NOCHECK ADD  CONSTRAINT [FK_tb_S4EItens_Campanha] FOREIGN KEY([cd_campanha])
REFERENCES [dbo].[Campanha] ([cd_campanha])
ALTER TABLE [dbo].[tb_S4EItens] CHECK CONSTRAINT [FK_tb_S4EItens_Campanha]
