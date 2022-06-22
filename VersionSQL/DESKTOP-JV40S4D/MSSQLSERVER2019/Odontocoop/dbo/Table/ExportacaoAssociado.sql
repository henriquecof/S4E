/****** Object:  Table [dbo].[ExportacaoAssociado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ExportacaoAssociado](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[chaveExportacao] [varchar](50) NOT NULL,
	[dados] [varchar](max) NOT NULL,
	[utilizado] [bit] NULL,
	[pago] [bit] NULL,
	[dtCadastro] [datetime] NOT NULL,
 CONSTRAINT [PK_ExportacaoAssociado] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IN_chaveExportacao] ON [dbo].[ExportacaoAssociado]
(
	[chaveExportacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
