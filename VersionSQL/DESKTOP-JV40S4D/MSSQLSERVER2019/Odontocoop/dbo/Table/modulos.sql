/****** Object:  Table [dbo].[modulos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[modulos](
	[cd_modulo] [int] IDENTITY(1,1) NOT NULL,
	[ds_modulo] [varchar](500) NOT NULL,
 CONSTRAINT [PK_modulos_1] PRIMARY KEY CLUSTERED 
(
	[cd_modulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
