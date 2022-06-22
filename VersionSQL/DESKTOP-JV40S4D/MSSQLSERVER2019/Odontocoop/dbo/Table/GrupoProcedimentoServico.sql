/****** Object:  Table [dbo].[GrupoProcedimentoServico]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoProcedimentoServico](
	[gpsId] [int] IDENTITY(1,1) NOT NULL,
	[gprId] [smallint] NOT NULL,
	[cd_servico] [int] NOT NULL,
	[gpsCoparticipacao] [bit] NOT NULL,
	[gpsExclusivo] [bit] NOT NULL,
 CONSTRAINT [PK_GrupoProcedimentoServico] PRIMARY KEY CLUSTERED 
(
	[gpsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_GrupoProcedimentoServico] ON [dbo].[GrupoProcedimentoServico]
(
	[gprId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_GrupoProcedimentoServico_1] ON [dbo].[GrupoProcedimentoServico]
(
	[cd_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_GrupoProcedimentoServico_2] ON [dbo].[GrupoProcedimentoServico]
(
	[gprId] ASC,
	[cd_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[GrupoProcedimentoServico]  WITH CHECK ADD  CONSTRAINT [FK_GrupoProcedimentoServico_GrupoProcedimento] FOREIGN KEY([gprId])
REFERENCES [dbo].[GrupoProcedimento] ([gprId])
ALTER TABLE [dbo].[GrupoProcedimentoServico] CHECK CONSTRAINT [FK_GrupoProcedimentoServico_GrupoProcedimento]
ALTER TABLE [dbo].[GrupoProcedimentoServico]  WITH CHECK ADD  CONSTRAINT [FK_GrupoProcedimentoServico_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[GrupoProcedimentoServico] CHECK CONSTRAINT [FK_GrupoProcedimentoServico_SERVICO]
