/****** Object:  Table [dbo].[EnderecoComplementar]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EnderecoComplementar](
	[ecoId] [int] IDENTITY(1,1) NOT NULL,
	[ecoUsuario] [int] NOT NULL,
	[cd_origeminformacao] [int] NOT NULL,
	[cd_tipo_endereco] [int] NOT NULL,
	[chave_tipologradouro] [int] NOT NULL,
	[ecoEndereco] [varchar](100) NOT NULL,
	[ecoNumero] [int] NULL,
	[ecoComplemento] [varchar](100) NULL,
	[baiId] [int] NULL,
	[ecoCEP] [varchar](8) NOT NULL,
	[cd_municipio] [int] NULL,
	[ufId] [smallint] NULL,
	[ecoOBS] [varchar](500) NULL,
	[ecoDtCadastro] [datetime] NOT NULL,
	[ecoDtExclusao] [datetime] NULL,
	[divulgaRede] [bit] NULL,
	[ecoEndBoleto] [varchar](40) NULL,
 CONSTRAINT [PK_EnderecoComplementar] PRIMARY KEY CLUSTERED 
(
	[ecoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_EnderecoComplementar] ON [dbo].[EnderecoComplementar]
(
	[ecoUsuario] ASC,
	[cd_origeminformacao] ASC,
	[cd_tipo_endereco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[EnderecoComplementar]  WITH CHECK ADD  CONSTRAINT [FK_EnderecoComplementar_Bairro] FOREIGN KEY([baiId])
REFERENCES [dbo].[Bairro] ([baiId])
ALTER TABLE [dbo].[EnderecoComplementar] CHECK CONSTRAINT [FK_EnderecoComplementar_Bairro]
ALTER TABLE [dbo].[EnderecoComplementar]  WITH CHECK ADD  CONSTRAINT [FK_EnderecoComplementar_MUNICIPIO] FOREIGN KEY([cd_municipio])
REFERENCES [dbo].[MUNICIPIO] ([CD_MUNICIPIO])
ALTER TABLE [dbo].[EnderecoComplementar] CHECK CONSTRAINT [FK_EnderecoComplementar_MUNICIPIO]
ALTER TABLE [dbo].[EnderecoComplementar]  WITH CHECK ADD  CONSTRAINT [FK_EnderecoComplementar_TB_OrigemInformacao] FOREIGN KEY([cd_origeminformacao])
REFERENCES [dbo].[TB_OrigemInformacao] ([cd_origeminformacao])
ALTER TABLE [dbo].[EnderecoComplementar] CHECK CONSTRAINT [FK_EnderecoComplementar_TB_OrigemInformacao]
ALTER TABLE [dbo].[EnderecoComplementar]  WITH CHECK ADD  CONSTRAINT [FK_EnderecoComplementar_TB_TIPOLOGRADOURO] FOREIGN KEY([chave_tipologradouro])
REFERENCES [dbo].[TB_TIPOLOGRADOURO] ([CHAVE_TIPOLOGRADOURO])
ALTER TABLE [dbo].[EnderecoComplementar] CHECK CONSTRAINT [FK_EnderecoComplementar_TB_TIPOLOGRADOURO]
ALTER TABLE [dbo].[EnderecoComplementar]  WITH CHECK ADD  CONSTRAINT [FK_EnderecoComplementar_UF] FOREIGN KEY([ufId])
REFERENCES [dbo].[UF] ([ufId])
ALTER TABLE [dbo].[EnderecoComplementar] CHECK CONSTRAINT [FK_EnderecoComplementar_UF]
