/****** Object:  Table [dbo].[tipo_procedimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tipo_procedimento](
	[tp_procedimento] [smallint] NOT NULL,
	[nm_tipo_procedimento] [nvarchar](15) NULL,
 CONSTRAINT [PK_tipo_procedimento] PRIMARY KEY CLUSTERED 
(
	[tp_procedimento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
