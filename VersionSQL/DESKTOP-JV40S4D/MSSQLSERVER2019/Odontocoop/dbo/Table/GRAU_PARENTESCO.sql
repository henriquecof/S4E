/****** Object:  Table [dbo].[GRAU_PARENTESCO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GRAU_PARENTESCO](
	[cd_grau_parentesco] [smallint] NOT NULL,
	[nm_grau_parentesco] [varchar](50) NULL,
	[fl_adicional] [bit] NOT NULL,
	[nm_sigla] [varchar](7) NULL,
	[ativo] [bit] NULL,
	[fl_semvalor_ind] [bit] NOT NULL,
	[fl_semvalor_fam] [bit] NOT NULL,
	[fl_semvalor_cas] [bit] NOT NULL,
	[cd_grau_ans] [smallint] NULL,
 CONSTRAINT [PK_GRAU_PARENTESCO] PRIMARY KEY NONCLUSTERED 
(
	[cd_grau_parentesco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
