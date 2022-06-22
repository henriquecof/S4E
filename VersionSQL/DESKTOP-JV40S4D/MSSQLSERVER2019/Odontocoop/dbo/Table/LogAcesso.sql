/****** Object:  Table [dbo].[LogAcesso]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LogAcesso](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tipoUsuario] [tinyint] NOT NULL,
	[codigoUsuario] [int] NOT NULL,
	[data] [datetime] NOT NULL,
	[ip] [varchar](50) NULL,
	[tipoAcesso] [tinyint] NULL,
 CONSTRAINT [PK_LogAcesso2] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
