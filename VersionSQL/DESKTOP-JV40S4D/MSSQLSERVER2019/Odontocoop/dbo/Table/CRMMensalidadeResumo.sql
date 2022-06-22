/****** Object:  Table [dbo].[CRMMensalidadeResumo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMMensalidadeResumo](
	[codigo] [int] NOT NULL,
	[tipo] [smallint] NOT NULL,
	[dias] [int] NULL,
 CONSTRAINT [PK_CRMMensalidadeResumo_1] PRIMARY KEY NONCLUSTERED 
(
	[codigo] ASC,
	[tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
