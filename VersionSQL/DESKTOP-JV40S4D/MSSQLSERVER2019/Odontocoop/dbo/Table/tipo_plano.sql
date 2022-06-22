/****** Object:  Table [dbo].[tipo_plano]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tipo_plano](
	[cd_tipo_plano] [smallint] IDENTITY(1,1) NOT NULL,
	[ds_tipo_plano] [varchar](50) NULL,
 CONSTRAINT [PK_tipo_plano] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_plano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
