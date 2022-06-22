/****** Object:  Table [dbo].[DentistaTransferenciaMotivo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DentistaTransferenciaMotivo](
	[id] [int] NOT NULL,
	[ds_motivo] [varchar](200) NULL,
	[fl_ativo] [bit] NULL,
 CONSTRAINT [PK_DentistaTransferenciaMotivo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
