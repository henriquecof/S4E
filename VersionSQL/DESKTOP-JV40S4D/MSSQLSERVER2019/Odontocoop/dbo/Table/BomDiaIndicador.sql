﻿/****** Object:  Table [dbo].[BomDiaIndicador]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BomDiaIndicador](
	[bdiId] [smallint] IDENTITY(1,1) NOT NULL,
	[bdaId] [smallint] NOT NULL,
	[bdgId] [smallint] NOT NULL,
	[bdiDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_BomDiaIndicador] PRIMARY KEY CLUSTERED 
(
	[bdiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_BomDiaIndicador] ON [dbo].[BomDiaIndicador]
(
	[bdaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_BomDiaIndicador_1] ON [dbo].[BomDiaIndicador]
(
	[bdgId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[BomDiaIndicador]  WITH NOCHECK ADD  CONSTRAINT [FK_BomDiaIndicador_BomDiaArea] FOREIGN KEY([bdaId])
REFERENCES [dbo].[BomDiaArea] ([bdaId])
ALTER TABLE [dbo].[BomDiaIndicador] CHECK CONSTRAINT [FK_BomDiaIndicador_BomDiaArea]
ALTER TABLE [dbo].[BomDiaIndicador]  WITH NOCHECK ADD  CONSTRAINT [FK_BomDiaIndicador_BomDiaIndicadorGestao] FOREIGN KEY([bdgId])
REFERENCES [dbo].[BomDiaIndicadorGestao] ([bdgId])
ALTER TABLE [dbo].[BomDiaIndicador] CHECK CONSTRAINT [FK_BomDiaIndicador_BomDiaIndicadorGestao]
