/****** Object:  Table [dbo].[tiss_lote_item_erro_convenio]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tiss_lote_item_erro_convenio](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_lote] [int] NOT NULL,
	[numeroguiaprestador] [varchar](50) NOT NULL,
	[erro] [varchar](max) NOT NULL,
 CONSTRAINT [pk_tiss_lote_item_erro_convenio] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
