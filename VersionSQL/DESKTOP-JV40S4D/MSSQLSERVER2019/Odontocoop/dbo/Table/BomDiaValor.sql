/****** Object:  Table [dbo].[BomDiaValor]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BomDiaValor](
	[bdvId] [int] IDENTITY(1,1) NOT NULL,
	[bdiId] [smallint] NULL,
	[bdvValor] [real] NULL,
	[bdvData] [datetime] NULL,
 CONSTRAINT [PK_BomDiaValor] PRIMARY KEY CLUSTERED 
(
	[bdvId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_BomDiaValor] ON [dbo].[BomDiaValor]
(
	[bdiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_BomDiaValor_1] ON [dbo].[BomDiaValor]
(
	[bdvData] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[BomDiaValor]  WITH NOCHECK ADD  CONSTRAINT [FK_BomDiaValor_BomDiaIndicador] FOREIGN KEY([bdiId])
REFERENCES [dbo].[BomDiaIndicador] ([bdiId])
ALTER TABLE [dbo].[BomDiaValor] CHECK CONSTRAINT [FK_BomDiaValor_BomDiaIndicador]
