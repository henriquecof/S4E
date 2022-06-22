/****** Object:  Table [dbo].[CRMMotivoDetalhadoTipoSolicitante]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMMotivoDetalhadoTipoSolicitante](
	[mdeId] [smallint] NOT NULL,
	[tsoId] [smallint] NOT NULL,
 CONSTRAINT [PK_CRMMotivoDetalhado_TipoDestinatario] PRIMARY KEY CLUSTERED 
(
	[mdeId] ASC,
	[tsoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CRMMotivoDetalhadoTipoSolicitante]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMMotivoDetalhado_TipoDestinatario_CRMMotivoDetalhado] FOREIGN KEY([mdeId])
REFERENCES [dbo].[CRMMotivoDetalhado] ([mdeId])
ALTER TABLE [dbo].[CRMMotivoDetalhadoTipoSolicitante] CHECK CONSTRAINT [FK_CRMMotivoDetalhado_TipoDestinatario_CRMMotivoDetalhado]
ALTER TABLE [dbo].[CRMMotivoDetalhadoTipoSolicitante]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMMotivoDetalhadoTipoSolicitante_CRMTipoSolicitante] FOREIGN KEY([tsoId])
REFERENCES [dbo].[CRMTipoSolicitante] ([tsoId])
ALTER TABLE [dbo].[CRMMotivoDetalhadoTipoSolicitante] CHECK CONSTRAINT [FK_CRMMotivoDetalhadoTipoSolicitante_CRMTipoSolicitante]
