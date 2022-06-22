/****** Object:  Table [dbo].[TB_MigracaoEmpresaAssociadoPlano]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_MigracaoEmpresaAssociadoPlano](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_empresaOrigem] [bigint] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_empresaDestino] [bigint] NOT NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[usuario_cadastro] [int] NOT NULL,
	[cd_planoOrigem] [int] NOT NULL,
	[cd_planoDestino] [int] NOT NULL,
	[dt_processamento] [datetime] NULL,
	[fl_migraComissaoNaoPaga] [bit] NULL,
 CONSTRAINT [PK_TB_MigracaoEmpresaAssociadoPlano] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_MigracaoEmpresaAssociadoPlano]  WITH CHECK ADD  CONSTRAINT [FK_TB_MigracaoEmpresaAssociadoPlano_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[TB_MigracaoEmpresaAssociadoPlano] CHECK CONSTRAINT [FK_TB_MigracaoEmpresaAssociadoPlano_DEPENDENTES]
ALTER TABLE [dbo].[TB_MigracaoEmpresaAssociadoPlano]  WITH CHECK ADD  CONSTRAINT [FK_TB_MigracaoEmpresaAssociadoPlano_EMPRESA] FOREIGN KEY([cd_empresaDestino])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[TB_MigracaoEmpresaAssociadoPlano] CHECK CONSTRAINT [FK_TB_MigracaoEmpresaAssociadoPlano_EMPRESA]
ALTER TABLE [dbo].[TB_MigracaoEmpresaAssociadoPlano]  WITH CHECK ADD  CONSTRAINT [FK_TB_MigracaoEmpresaAssociadoPlano_EMPRESA1] FOREIGN KEY([cd_empresaOrigem])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[TB_MigracaoEmpresaAssociadoPlano] CHECK CONSTRAINT [FK_TB_MigracaoEmpresaAssociadoPlano_EMPRESA1]
ALTER TABLE [dbo].[TB_MigracaoEmpresaAssociadoPlano]  WITH CHECK ADD  CONSTRAINT [FK_TB_MigracaoEmpresaAssociadoPlano_PLANOS] FOREIGN KEY([cd_planoDestino])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[TB_MigracaoEmpresaAssociadoPlano] CHECK CONSTRAINT [FK_TB_MigracaoEmpresaAssociadoPlano_PLANOS]
ALTER TABLE [dbo].[TB_MigracaoEmpresaAssociadoPlano]  WITH CHECK ADD  CONSTRAINT [FK_TB_MigracaoEmpresaAssociadoPlano_PLANOS1] FOREIGN KEY([cd_planoOrigem])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[TB_MigracaoEmpresaAssociadoPlano] CHECK CONSTRAINT [FK_TB_MigracaoEmpresaAssociadoPlano_PLANOS1]
