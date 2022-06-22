/****** Object:  Table [dbo].[tipo_mensagem]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tipo_mensagem](
	[cd_tipo_mensagem] [smallint] NOT NULL,
	[ds_tipo_mensagem] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tipo_mensagem] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_mensagem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
