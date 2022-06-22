/****** Object:  Table [dbo].[GRUPO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GRUPO](
	[CD_GRUPO] [smallint] IDENTITY(1,1) NOT NULL,
	[NM_GRUPO] [varchar](50) NOT NULL,
	[NR_CGC] [varchar](14) NULL,
	[TP_EMPRESA] [smallint] NULL,
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
	[VisualizaBoleto] [bit] NULL,
	[VisualizaFaturas] [bit] NULL,
	[AcessoPortal] [bit] NULL,
	[fl_acesso_restrito_portal] [bit] NULL,
	[portalMovimentacaoCadastral] [bit] NULL,
 CONSTRAINT [PK_GRUPO] PRIMARY KEY NONCLUSTERED 
(
	[CD_GRUPO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[GRUPO]  WITH CHECK ADD  CONSTRAINT [FK_GRUPO_Bairro] FOREIGN KEY([BaiId])
REFERENCES [dbo].[Bairro] ([baiId])
ALTER TABLE [dbo].[GRUPO] CHECK CONSTRAINT [FK_GRUPO_Bairro]
ALTER TABLE [dbo].[GRUPO]  WITH CHECK ADD  CONSTRAINT [FK_GRUPO_MUNICIPIO] FOREIGN KEY([cd_municipio])
REFERENCES [dbo].[MUNICIPIO] ([CD_MUNICIPIO])
ALTER TABLE [dbo].[GRUPO] CHECK CONSTRAINT [FK_GRUPO_MUNICIPIO]
ALTER TABLE [dbo].[GRUPO]  WITH CHECK ADD  CONSTRAINT [FK_GRUPO_TB_TIPOLOGRADOURO] FOREIGN KEY([CHAVE_TIPOLOGRADOURO])
REFERENCES [dbo].[TB_TIPOLOGRADOURO] ([CHAVE_TIPOLOGRADOURO])
ALTER TABLE [dbo].[GRUPO] CHECK CONSTRAINT [FK_GRUPO_TB_TIPOLOGRADOURO]
ALTER TABLE [dbo].[GRUPO]  WITH CHECK ADD  CONSTRAINT [FK_GRUPO_TIPO_EMPRESA] FOREIGN KEY([TP_EMPRESA])
REFERENCES [dbo].[TIPO_EMPRESA] ([tp_empresa])
ALTER TABLE [dbo].[GRUPO] CHECK CONSTRAINT [FK_GRUPO_TIPO_EMPRESA]
ALTER TABLE [dbo].[GRUPO]  WITH CHECK ADD  CONSTRAINT [FK_GRUPO_UF_99] FOREIGN KEY([ufId])
REFERENCES [dbo].[UF] ([ufId])
ALTER TABLE [dbo].[GRUPO] CHECK CONSTRAINT [FK_GRUPO_UF_99]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Grupo|&' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GRUPO', @level2type=N'COLUMN',@level2name=N'NM_GRUPO'
