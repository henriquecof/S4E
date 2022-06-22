/****** Object:  Table [dbo].[PropostaComercialDependentes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PropostaComercialDependentes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_plano] [int] NULL,
	[numero_beneficiarios] [int] NULL,
	[coparticipacao] [int] NULL,
	[vl_plano] [money] NULL,
	[id_proposta_comercial] [int] NULL,
	[tipo_contratacao] [smallint] NULL,
	[QuantidadeTitular] [int] NULL,
	[QuantidadeDependente] [int] NULL,
	[QuantidadeAgregado] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[PropostaComercialDependentes]  WITH CHECK ADD  CONSTRAINT [FK_PropostaComercialDependentes_PropostaComercial] FOREIGN KEY([id_proposta_comercial])
REFERENCES [dbo].[PropostaComercial] ([id])
ALTER TABLE [dbo].[PropostaComercialDependentes] CHECK CONSTRAINT [FK_PropostaComercialDependentes_PropostaComercial]
ALTER TABLE [dbo].[PropostaComercialDependentes]  WITH CHECK ADD  CONSTRAINT [PropostaComercialDependentes_PLANOS] FOREIGN KEY([cd_plano])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[PropostaComercialDependentes] CHECK CONSTRAINT [PropostaComercialDependentes_PLANOS]
