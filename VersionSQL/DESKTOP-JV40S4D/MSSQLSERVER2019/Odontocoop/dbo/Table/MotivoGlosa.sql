/****** Object:  Table [dbo].[MotivoGlosa]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MotivoGlosa](
	[mglId] [int] IDENTITY(1,1) NOT NULL,
	[mglDescricao] [varchar](300) NOT NULL,
	[mglAtivo] [bit] NULL,
	[idTipoAnaliseAuditoria] [tinyint] NULL,
 CONSTRAINT [PK_MotivoGlosa] PRIMARY KEY CLUSTERED 
(
	[mglId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
