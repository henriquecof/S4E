/****** Object:  Table [dbo].[CRMChamadoOcorrencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMChamadoOcorrencia](
	[cocId] [int] IDENTITY(1,1) NOT NULL,
	[chaId] [int] NOT NULL,
	[cocDescricao] [varchar](max) NULL,
	[cocDtCadastro] [datetime] NOT NULL,
	[TipoUsuario] [smallint] NULL,
	[Usuario] [int] NULL,
	[cocProtocolo] [varchar](50) NULL,
	[cocProtocoloPABX] [varchar](50) NULL,
	[exibir] [bit] NULL,
 CONSTRAINT [PK_CRMChamadoOcorrencia] PRIMARY KEY CLUSTERED 
(
	[cocId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_CRMChamadoOcorrencia] ON [dbo].[CRMChamadoOcorrencia]
(
	[chaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CRMChamadoOcorrencia_1] ON [dbo].[CRMChamadoOcorrencia]
(
	[cocDtCadastro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CRMChamadoOcorrencia] ADD  CONSTRAINT [DF_CRMChamadoOcorrencia_CRMTipoUsuario]  DEFAULT ((1)) FOR [TipoUsuario]
ALTER TABLE [dbo].[CRMChamadoOcorrencia]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMChamadoOcorrencia_CRMChamado] FOREIGN KEY([chaId])
REFERENCES [dbo].[CRMChamado] ([chaId])
ALTER TABLE [dbo].[CRMChamadoOcorrencia] CHECK CONSTRAINT [FK_CRMChamadoOcorrencia_CRMChamado]
ALTER TABLE [dbo].[CRMChamadoOcorrencia]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMChamadoOcorrencia_CRMTipoSolicitante] FOREIGN KEY([TipoUsuario])
REFERENCES [dbo].[CRMTipoSolicitante] ([tsoId])
ALTER TABLE [dbo].[CRMChamadoOcorrencia] CHECK CONSTRAINT [FK_CRMChamadoOcorrencia_CRMTipoSolicitante]
