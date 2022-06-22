/****** Object:  Table [dbo].[PropostaComercial]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PropostaComercial](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[numero_estudo] [varchar](50) NULL,
	[nome_contratante] [varchar](50) NULL,
	[cnpj] [varchar](20) NULL,
	[LogCep] [varchar](8) NULL,
	[CHAVE_TIPOLOGRADOURO] [int] NULL,
	[EndLogradouro] [varchar](100) NULL,
	[EndNumero] [int] NULL,
	[EndComplemento] [varchar](100) NULL,
	[BaiId] [int] NULL,
	[CidID] [int] NULL,
	[ufId] [smallint] NULL,
	[descricao_funcionarios] [varchar](50) NULL,
	[responsavel] [int] NULL,
	[corretora] [int] NULL,
	[data_cadastro] [datetime] NULL,
	[data_exclusao] [datetime] NULL,
	[validade] [int] NULL,
	[cd_centro_custo] [smallint] NULL,
	[vencimento_empresa] [tinyint] NULL,
	[vigencia] [smallint] NULL,
	[celular] [varchar](50) NULL,
	[sexo] [tinyint] NULL,
	[dataNascimento] [datetime] NULL,
	[cpf] [varchar](11) NULL,
	[identidade] [varchar](20) NULL,
	[orgaoEmissor] [varchar](5) NULL,
	[estadoCivil] [tinyint] NULL,
	[adesionista] [int] NULL,
	[carencia] [smallint] NULL,
	[razao_social] [varchar](50) NULL,
	[ramo_atuacao] [smallint] NULL,
	[quantidade_funcionario] [int] NULL,
	[tipo_adesao] [int] NULL,
	[nome_contato] [varchar](50) NULL,
	[cargo] [varchar](50) NULL,
	[email] [varchar](50) NULL,
	[telefone] [varchar](50) NULL,
	[observacoes] [varchar](100) NULL,
	[plano_existente_descricao] [varchar](max) NULL,
	[ValorPlanoExistente] [money] NULL,
	[DataVigenciaPlanoExistente] [datetime] NULL,
	[tp_empresa] [smallint] NULL,
 CONSTRAINT [PK_PropostaComercial] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[PropostaComercial]  WITH CHECK ADD FOREIGN KEY([ramo_atuacao])
REFERENCES [dbo].[ramo_atividade] ([cd_ramo_atividade])
ALTER TABLE [dbo].[PropostaComercial]  WITH CHECK ADD  CONSTRAINT [FK_PropostaComercial_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[PropostaComercial] CHECK CONSTRAINT [FK_PropostaComercial_Centro_Custo]
ALTER TABLE [dbo].[PropostaComercial]  WITH CHECK ADD  CONSTRAINT [FK_PropostaComercial_FUNCIONARIO] FOREIGN KEY([responsavel])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[PropostaComercial] CHECK CONSTRAINT [FK_PropostaComercial_FUNCIONARIO]
ALTER TABLE [dbo].[PropostaComercial]  WITH CHECK ADD  CONSTRAINT [FK_PropostaComercial_FUNCIONARIO1] FOREIGN KEY([corretora])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[PropostaComercial] CHECK CONSTRAINT [FK_PropostaComercial_FUNCIONARIO1]
ALTER TABLE [dbo].[PropostaComercial]  WITH CHECK ADD  CONSTRAINT [FK_PropostaComercial_FUNCIONARIO2] FOREIGN KEY([adesionista])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[PropostaComercial] CHECK CONSTRAINT [FK_PropostaComercial_FUNCIONARIO2]
ALTER TABLE [dbo].[PropostaComercial]  WITH CHECK ADD  CONSTRAINT [FK_PropostaComercial_tp_empresa_TIPO_EMPRESA_tp_empresa] FOREIGN KEY([tp_empresa])
REFERENCES [dbo].[TIPO_EMPRESA] ([tp_empresa])
ALTER TABLE [dbo].[PropostaComercial] CHECK CONSTRAINT [FK_PropostaComercial_tp_empresa_TIPO_EMPRESA_tp_empresa]
ALTER TABLE [dbo].[PropostaComercial]  WITH CHECK ADD  CONSTRAINT [PropostaComercial_Bairro] FOREIGN KEY([BaiId])
REFERENCES [dbo].[Bairro] ([baiId])
ALTER TABLE [dbo].[PropostaComercial] CHECK CONSTRAINT [PropostaComercial_Bairro]
ALTER TABLE [dbo].[PropostaComercial]  WITH CHECK ADD  CONSTRAINT [PropostaComercial_MUNICIPIO] FOREIGN KEY([CidID])
REFERENCES [dbo].[MUNICIPIO] ([CD_MUNICIPIO])
ALTER TABLE [dbo].[PropostaComercial] CHECK CONSTRAINT [PropostaComercial_MUNICIPIO]
ALTER TABLE [dbo].[PropostaComercial]  WITH CHECK ADD  CONSTRAINT [PropostaComercial_TB_TIPOLOGRADOURO] FOREIGN KEY([CHAVE_TIPOLOGRADOURO])
REFERENCES [dbo].[TB_TIPOLOGRADOURO] ([CHAVE_TIPOLOGRADOURO])
ALTER TABLE [dbo].[PropostaComercial] CHECK CONSTRAINT [PropostaComercial_TB_TIPOLOGRADOURO]
ALTER TABLE [dbo].[PropostaComercial]  WITH CHECK ADD  CONSTRAINT [PropostaComercial_UF] FOREIGN KEY([ufId])
REFERENCES [dbo].[UF] ([ufId])
ALTER TABLE [dbo].[PropostaComercial] CHECK CONSTRAINT [PropostaComercial_UF]
