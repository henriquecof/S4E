/****** Object:  Table [dbo].[FilialBiometria]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[FilialBiometria](
	[fbiId] [int] IDENTITY(1,1) NOT NULL,
	[cd_filial] [int] NOT NULL,
	[cd_modelo_biometria] [smallint] NOT NULL,
	[serial] [varchar](50) NOT NULL,
	[fbiIdentificacaoComputador] [varchar](50) NULL,
	[fbiDtCadastro] [datetime] NOT NULL,
	[fbiDtExclusao] [datetime] NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[AparelhoDevolvido] [bit] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[FilialBiometria]  WITH CHECK ADD  CONSTRAINT [FK_FilialBiometria_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[FilialBiometria] CHECK CONSTRAINT [FK_FilialBiometria_FILIAL]
ALTER TABLE [dbo].[FilialBiometria]  WITH CHECK ADD  CONSTRAINT [FK_FilialBiometria_modelo_biometria] FOREIGN KEY([cd_modelo_biometria])
REFERENCES [dbo].[modelo_biometria] ([cd_modelo_Biometria])
ALTER TABLE [dbo].[FilialBiometria] CHECK CONSTRAINT [FK_FilialBiometria_modelo_biometria]
