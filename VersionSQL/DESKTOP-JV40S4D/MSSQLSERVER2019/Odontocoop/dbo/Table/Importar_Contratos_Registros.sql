/****** Object:  Table [dbo].[Importar_Contratos_Registros]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Importar_Contratos_Registros](
	[cd_sequencial] [int] NOT NULL,
	[linha] [int] NOT NULL,
	[cd_sequencial_dep] [int] NULL,
	[matricula] [varchar](30) NULL,
	[cpf] [varchar](11) NULL,
	[nome] [varchar](60) NULL,
	[dt_nascimento] [date] NULL,
	[nm_mae] [varchar](60) NULL,
	[rg] [varchar](20) NULL,
	[cd_grau_parentesco] [smallint] NULL,
	[sexo] [varchar](1) NULL,
	[cep] [varchar](8) NULL,
	[EndNumero] [int] NULL,
	[EndComplemento] [varchar](100) NULL,
	[telefone] [varchar](11) NULL,
	[e_mail] [varchar](100) NULL,
	[cd_plano] [smallint] NULL,
	[depId] [smallint] NULL,
	[complemento] [varchar](200) NULL,
	[obs] [varchar](1000) NULL,
	[cns] [varchar](50) NULL,
	[nm_responsavel] [varchar](60) NULL,
	[cpf_responsavel] [varchar](11) NULL,
	[nr_carteira] [varchar](30) NULL,
	[dt_nasc_responsavel] [datetime] NULL,
	[cd_associado] [int] NULL,
	[telefone1] [varchar](11) NULL,
	[NM_DEPENDENTE] [varchar](100) NULL,
	[ESTADO_CIVIL] [varchar](100) NULL,
	[RG_ORGAO] [varchar](100) NULL,
	[TELEFONE2] [varchar](100) NULL,
	[CONTRATO_EMPRESA] [varchar](100) NULL,
	[CARENCIA] [varchar](100) NULL,
	[SITUACAO] [varchar](100) NULL,
	[DTADESAO] [varchar](100) NULL,
	[COD_VENDEDOR] [varchar](100) NULL,
	[MODELO] [varchar](100) NULL,
	[COD_ADESIONISTA] [varchar](100) NULL,
	[DEPTO_GRP] [varchar](100) NULL,
	[CT_CUSTO] [varchar](100) NULL,
	[DT_CANC] [varchar](100) NULL,
	[COD_MOTIVOCANC] [varchar](100) NULL,
	[N_BANCO_COB] [varchar](100) NULL,
	[N_AGENC_COB] [varchar](100) NULL,
	[N_DV_AGENC_COB] [varchar](100) NULL,
	[N_OP_BANCO] [varchar](100) NULL,
	[N_CONTA_COB] [varchar](100) NULL,
	[N_DV_CONTA_COB] [varchar](100) NULL,
	[NRO_CARTAO_COB] [varchar](100) NULL,
	[DIG_CARTAO_COB] [varchar](100) NULL,
	[ANO_CARTAO_COB] [varchar](100) NULL,
	[MES_CARTAO_COB] [varchar](100) NULL,
	[anoMes1Pgto] [varchar](6) NULL,
 CONSTRAINT [PK_Importar_Contratos_Registros] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC,
	[linha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Importar_Contratos_Registros]  WITH CHECK ADD  CONSTRAINT [FK_Importar_Contratos_Registros_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[Importar_Contratos_Registros] CHECK CONSTRAINT [FK_Importar_Contratos_Registros_DEPENDENTES]
ALTER TABLE [dbo].[Importar_Contratos_Registros]  WITH CHECK ADD  CONSTRAINT [FK_Importar_Contratos_Registros_Importar_Contratos] FOREIGN KEY([cd_sequencial])
REFERENCES [dbo].[Importar_Contratos] ([cd_sequencial])
ALTER TABLE [dbo].[Importar_Contratos_Registros] CHECK CONSTRAINT [FK_Importar_Contratos_Registros_Importar_Contratos]
