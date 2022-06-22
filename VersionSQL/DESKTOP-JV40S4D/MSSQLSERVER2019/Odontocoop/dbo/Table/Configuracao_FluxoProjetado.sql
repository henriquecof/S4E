/****** Object:  Table [dbo].[Configuracao_FluxoProjetado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Configuracao_FluxoProjetado](
	[cd_centro_custo] [smallint] NOT NULL,
	[dia] [smallint] NOT NULL,
	[vl_acumulado] [money] NULL,
	[perc_calculado] [float] NULL,
	[perc_informado] [float] NULL,
 CONSTRAINT [PK_Configuracao_FluxoProjetado] PRIMARY KEY CLUSTERED 
(
	[cd_centro_custo] ASC,
	[dia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Configuracao_FluxoProjetado]  WITH CHECK ADD  CONSTRAINT [FK_Configuracao_FluxoProjetado_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[Configuracao_FluxoProjetado] CHECK CONSTRAINT [FK_Configuracao_FluxoProjetado_Centro_Custo]
ALTER TABLE [dbo].[Configuracao_FluxoProjetado]  WITH CHECK ADD  CONSTRAINT [FK_Configuracao_FluxoProjetado_DIA_PAGAMENTO] FOREIGN KEY([dia])
REFERENCES [dbo].[DIA_PAGAMENTO] ([cd_dia])
ALTER TABLE [dbo].[Configuracao_FluxoProjetado] CHECK CONSTRAINT [FK_Configuracao_FluxoProjetado_DIA_PAGAMENTO]
