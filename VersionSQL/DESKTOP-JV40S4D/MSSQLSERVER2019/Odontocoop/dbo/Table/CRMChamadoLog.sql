﻿/****** Object:  Table [dbo].[CRMChamadoLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMChamadoLog](
	[cloId] [int] IDENTITY(1,1) NOT NULL,
	[chaId] [int] NOT NULL,
	[cloDtCadastro] [datetime] NOT NULL,
	[tloId] [tinyint] NOT NULL,
	[TipoUsuario] [smallint] NOT NULL,
	[Usuario] [int] NOT NULL,
	[UsuarioNovoResponsavel] [int] NULL,
	[cgrIdNovoResponsavel] [smallint] NULL,
 CONSTRAINT [PK_CRMChamadoLog] PRIMARY KEY CLUSTERED 
(
	[cloId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_CRMChamadoLog] ON [dbo].[CRMChamadoLog]
(
	[chaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CRMChamadoLog_1] ON [dbo].[CRMChamadoLog]
(
	[cloDtCadastro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CRMChamadoLog_2] ON [dbo].[CRMChamadoLog]
(
	[tloId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CRMChamadoLog_3] ON [dbo].[CRMChamadoLog]
(
	[Usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CRMChamadoLog_4] ON [dbo].[CRMChamadoLog]
(
	[UsuarioNovoResponsavel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CRMChamadoLog_5] ON [dbo].[CRMChamadoLog]
(
	[chaId] ASC,
	[Usuario] ASC,
	[tloId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CRMChamadoLog] ADD  CONSTRAINT [DF_CRMChamadoLog_CRMTipoUsuario]  DEFAULT ((1)) FOR [TipoUsuario]
ALTER TABLE [dbo].[CRMChamadoLog]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMChamadoLog_CRMChamado] FOREIGN KEY([chaId])
REFERENCES [dbo].[CRMChamado] ([chaId])
ALTER TABLE [dbo].[CRMChamadoLog] CHECK CONSTRAINT [FK_CRMChamadoLog_CRMChamado]
ALTER TABLE [dbo].[CRMChamadoLog]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMChamadoLog_CRMChamadoLog] FOREIGN KEY([cloId])
REFERENCES [dbo].[CRMChamadoLog] ([cloId])
ALTER TABLE [dbo].[CRMChamadoLog] CHECK CONSTRAINT [FK_CRMChamadoLog_CRMChamadoLog]
ALTER TABLE [dbo].[CRMChamadoLog]  WITH CHECK ADD  CONSTRAINT [FK_CRMChamadoLog_CRMGrupoResposanvel] FOREIGN KEY([cgrIdNovoResponsavel])
REFERENCES [dbo].[CRMGrupoResponsavel] ([cgrId])
ALTER TABLE [dbo].[CRMChamadoLog] CHECK CONSTRAINT [FK_CRMChamadoLog_CRMGrupoResposanvel]
ALTER TABLE [dbo].[CRMChamadoLog]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMChamadoLog_CRMTipoLog] FOREIGN KEY([tloId])
REFERENCES [dbo].[CRMTipoLog] ([tloId])
ALTER TABLE [dbo].[CRMChamadoLog] CHECK CONSTRAINT [FK_CRMChamadoLog_CRMTipoLog]
ALTER TABLE [dbo].[CRMChamadoLog]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMChamadoLog_CRMTipoSolicitante] FOREIGN KEY([TipoUsuario])
REFERENCES [dbo].[CRMTipoSolicitante] ([tsoId])
ALTER TABLE [dbo].[CRMChamadoLog] CHECK CONSTRAINT [FK_CRMChamadoLog_CRMTipoSolicitante]