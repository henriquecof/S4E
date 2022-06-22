/****** Object:  Table [dbo].[UsuarioCPFLiberado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[UsuarioCPFLiberado](
	[uclID] [int] IDENTITY(1,1) NOT NULL,
	[uclCPF] [varchar](11) NOT NULL,
	[uclFL_VALIDO] [bit] NULL,
 CONSTRAINT [PK_UsuarioCPFLiberado] PRIMARY KEY CLUSTERED 
(
	[uclID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
