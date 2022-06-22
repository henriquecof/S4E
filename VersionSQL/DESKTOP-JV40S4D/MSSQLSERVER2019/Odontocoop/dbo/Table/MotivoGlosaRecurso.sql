/****** Object:  Table [dbo].[MotivoGlosaRecurso]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MotivoGlosaRecurso](
	[mgrId] [int] NOT NULL,
	[mgrDescricao] [varchar](200) NOT NULL,
 CONSTRAINT [PK_MotivoGlosaRecurso] PRIMARY KEY CLUSTERED 
(
	[mgrId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
