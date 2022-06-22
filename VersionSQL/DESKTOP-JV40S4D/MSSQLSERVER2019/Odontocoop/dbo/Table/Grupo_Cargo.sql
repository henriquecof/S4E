/****** Object:  Table [dbo].[Grupo_Cargo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Grupo_Cargo](
	[cd_grupocargo] [tinyint] IDENTITY(1,1) NOT NULL,
	[nm_grupocargo] [varchar](100) NULL,
 CONSTRAINT [PK_Grupo_Cargo] PRIMARY KEY CLUSTERED 
(
	[cd_grupocargo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
