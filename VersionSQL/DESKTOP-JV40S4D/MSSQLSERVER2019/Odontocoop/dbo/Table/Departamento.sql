/****** Object:  Table [dbo].[Departamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Departamento](
	[depId] [smallint] IDENTITY(1,1) NOT NULL,
	[depDescricao] [varchar](50) NOT NULL,
	[NR_CGC] [varchar](14) NULL,
	[TP_EMPRESA] [smallint] NULL,
	[cd_grupo] [smallint] NULL,
	[Codigo_Sistema_Destino] [varchar](30) NULL,
	[Cep] [varchar](8) NULL,
	[CHAVE_TIPOLOGRADOURO] [int] NULL,
	[EndLogradouro] [varchar](100) NULL,
	[EndNumero] [int] NULL,
	[EndComplemento] [varchar](100) NULL,
	[ufId] [smallint] NULL,
	[cd_municipio] [int] NULL,
	[BaiId] [int] NULL,
	[dataInicial] [datetime] NULL,
	[dataFinal] [datetime] NULL,
 CONSTRAINT [PK_Departamento] PRIMARY KEY CLUSTERED 
(
	[depId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Departamento]  WITH CHECK ADD  CONSTRAINT [FK_Departamento_Bairro] FOREIGN KEY([BaiId])
REFERENCES [dbo].[Bairro] ([baiId])
ALTER TABLE [dbo].[Departamento] CHECK CONSTRAINT [FK_Departamento_Bairro]
ALTER TABLE [dbo].[Departamento]  WITH CHECK ADD  CONSTRAINT [FK_Departamento_GRUPO] FOREIGN KEY([cd_grupo])
REFERENCES [dbo].[GRUPO] ([CD_GRUPO])
ALTER TABLE [dbo].[Departamento] CHECK CONSTRAINT [FK_Departamento_GRUPO]
ALTER TABLE [dbo].[Departamento]  WITH CHECK ADD  CONSTRAINT [FK_Departamento_MUNICIPIO] FOREIGN KEY([cd_municipio])
REFERENCES [dbo].[MUNICIPIO] ([CD_MUNICIPIO])
ALTER TABLE [dbo].[Departamento] CHECK CONSTRAINT [FK_Departamento_MUNICIPIO]
ALTER TABLE [dbo].[Departamento]  WITH CHECK ADD  CONSTRAINT [FK_Departamento_TB_TIPOLOGRADOURO] FOREIGN KEY([CHAVE_TIPOLOGRADOURO])
REFERENCES [dbo].[TB_TIPOLOGRADOURO] ([CHAVE_TIPOLOGRADOURO])
ALTER TABLE [dbo].[Departamento] CHECK CONSTRAINT [FK_Departamento_TB_TIPOLOGRADOURO]
ALTER TABLE [dbo].[Departamento]  WITH CHECK ADD  CONSTRAINT [FK_Departamento_TIPO_EMPRESA] FOREIGN KEY([TP_EMPRESA])
REFERENCES [dbo].[TIPO_EMPRESA] ([tp_empresa])
ALTER TABLE [dbo].[Departamento] CHECK CONSTRAINT [FK_Departamento_TIPO_EMPRESA]
ALTER TABLE [dbo].[Departamento]  WITH CHECK ADD  CONSTRAINT [FK_Departamento_UF_99] FOREIGN KEY([ufId])
REFERENCES [dbo].[UF] ([ufId])
ALTER TABLE [dbo].[Departamento] CHECK CONSTRAINT [FK_Departamento_UF_99]
