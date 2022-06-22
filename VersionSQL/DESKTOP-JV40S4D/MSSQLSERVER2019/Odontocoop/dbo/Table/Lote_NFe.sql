/****** Object:  Table [dbo].[Lote_NFe]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_NFe](
	[lnfId] [int] IDENTITY(1,1) NOT NULL,
	[lnfDtInicial] [datetime] NOT NULL,
	[lnfDtFinal] [datetime] NOT NULL,
	[lnfDtEmissao] [datetime] NOT NULL,
	[lnfDtCadastro] [datetime] NOT NULL,
	[lnfDtExclusao] [datetime] NULL,
	[cd_centro_custo] [int] NOT NULL,
	[tp_empresa] [smallint] NOT NULL,
	[cd_empresa] [bigint] NULL,
	[cd_tipo_pagamento] [int] NULL,
	[lnfChave] [varchar](100) NOT NULL,
	[lnfProtocolo] [varchar](50) NULL,
	[lnfOBS] [varchar](1000) NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[dt_corte] [tinyint] NULL,
	[cd_empresaExceto] [varchar](1000) NULL,
	[cd_empresaGrupo] [varchar](1000) NULL,
	[cd_associadoGrupo] [varchar](1000) NULL,
	[cd_associadoExceto] [varchar](1000) NULL,
	[lnfDtCompetencia] [datetime] NULL,
	[lnfValorFatura] [money] NULL,
	[lnfValorReferencia] [money] NULL,
	[lnfQtde] [int] NULL,
	[lnfCOFINS] [money] NULL,
	[lnfCSLL] [money] NULL,
	[lnfINSS] [money] NULL,
	[lnfIR] [money] NULL,
	[lnfISS] [money] NULL,
	[lnfPIS] [money] NULL,
	[lnfCOFINS_Retido] [money] NULL,
	[lnfCSLL_Retido] [money] NULL,
	[lnfINSS_Retido] [money] NULL,
	[lnfIR_Retido] [money] NULL,
	[lnfISS_Retido] [money] NULL,
	[lnfPIS_Retido] [money] NULL,
	[cd_tipo_recebimento] [int] NULL,
	[cd_grupoEmpresaEspecifico] [varchar](1000) NULL,
	[cd_excetoGrupoEmpresa] [varchar](1000) NULL,
	[xmlEnvioNFe] [varchar](max) NULL,
	[ultimoCodigoNFe] [bigint] NULL,
	[dataChecagem] [datetime] NULL,
 CONSTRAINT [PK_Lote_NFe] PRIMARY KEY CLUSTERED 
(
	[lnfId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Lote_NFe]  WITH CHECK ADD  CONSTRAINT [FK_Lote_NFe_EMPRESA] FOREIGN KEY([cd_empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[Lote_NFe] CHECK CONSTRAINT [FK_Lote_NFe_EMPRESA]
ALTER TABLE [dbo].[Lote_NFe]  WITH CHECK ADD  CONSTRAINT [FK_Lote_NFe_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_NFe] CHECK CONSTRAINT [FK_Lote_NFe_FUNCIONARIO]
ALTER TABLE [dbo].[Lote_NFe]  WITH CHECK ADD  CONSTRAINT [FK_Lote_NFe_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_NFe] CHECK CONSTRAINT [FK_Lote_NFe_FUNCIONARIO1]
ALTER TABLE [dbo].[Lote_NFe]  WITH CHECK ADD  CONSTRAINT [FK_Lote_NFe_TIPO_EMPRESA] FOREIGN KEY([tp_empresa])
REFERENCES [dbo].[TIPO_EMPRESA] ([tp_empresa])
ALTER TABLE [dbo].[Lote_NFe] CHECK CONSTRAINT [FK_Lote_NFe_TIPO_EMPRESA]
ALTER TABLE [dbo].[Lote_NFe]  WITH CHECK ADD  CONSTRAINT [FK_Lote_NFe_TIPO_PAGAMENTO] FOREIGN KEY([cd_tipo_pagamento])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[Lote_NFe] CHECK CONSTRAINT [FK_Lote_NFe_TIPO_PAGAMENTO]
ALTER TABLE [dbo].[Lote_NFe]  WITH CHECK ADD  CONSTRAINT [FK_Lote_NFe_TIPO_PAGAMENTO1] FOREIGN KEY([cd_tipo_pagamento])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[Lote_NFe] CHECK CONSTRAINT [FK_Lote_NFe_TIPO_PAGAMENTO1]
