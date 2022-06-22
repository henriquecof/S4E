/****** Object:  Table [dbo].[ElegibilidadeBKP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ElegibilidadeBKP](
	[eleId] [int] NOT NULL,
	[cd_sequencial_dep] [int] NULL,
	[eleDtCadastro] [datetime] NULL,
	[cd_funcionarioCadastro] [int] NULL,
	[eleDtExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[eleDtValidade] [datetime] NULL,
	[eleUtilizado] [bit] NULL,
	[eleBiometria] [bit] NULL,
	[cd_filial] [int] NULL,
	[eledescricao] [varchar](50) NULL,
	[elechave] [varchar](50) NULL,
	[cd_funcionarioDentista] [int] NULL,
	[eleUrgencia] [bit] NULL,
	[eleOrtodontia] [bit] NULL,
	[eleTokenSMS] [bit] NULL,
	[eleTipoAtendimento] [tinyint] NULL,
	[idRequisicaoBioFacial] [varchar](50) NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[ElegibilidadeBKP]  WITH CHECK ADD  CONSTRAINT [FK_ElegibilidadeBKP_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[ElegibilidadeBKP] CHECK CONSTRAINT [FK_ElegibilidadeBKP_DEPENDENTES]
ALTER TABLE [dbo].[ElegibilidadeBKP]  WITH CHECK ADD  CONSTRAINT [FK_ElegibilidadeBKP_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[ElegibilidadeBKP] CHECK CONSTRAINT [FK_ElegibilidadeBKP_FILIAL]
