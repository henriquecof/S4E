/****** Object:  Table [dbo].[ext_endereco]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ext_endereco](
	[id_ext_endereco] [int] IDENTITY(1,1) NOT NULL,
	[id_ext_cadastro] [int] NULL,
	[logradouro] [varchar](45) NULL,
	[endereco] [varchar](255) NULL,
	[bairro] [varchar](45) NULL,
	[cidade] [varchar](45) NULL,
	[numero] [varchar](45) NULL,
	[cep] [varchar](9) NULL,
	[bloco] [varchar](45) NULL,
	[apto] [varchar](45) NULL,
	[casa] [varchar](45) NULL,
	[quadra] [varchar](45) NULL,
	[lote] [varchar](45) NULL,
	[complemento] [varchar](45) NULL,
	[uf] [varchar](2) NULL,
 CONSTRAINT [ext_endereco_1_3] PRIMARY KEY CLUSTERED 
(
	[id_ext_endereco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ext_endereco]  WITH CHECK ADD  CONSTRAINT [ext_endereco_ext_cadastro] FOREIGN KEY([id_ext_cadastro])
REFERENCES [dbo].[ext_cadastro] ([id_ext_cadastro])
ALTER TABLE [dbo].[ext_endereco] CHECK CONSTRAINT [ext_endereco_ext_cadastro]
