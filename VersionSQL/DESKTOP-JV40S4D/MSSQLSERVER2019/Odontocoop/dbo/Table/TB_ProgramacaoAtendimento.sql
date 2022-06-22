/****** Object:  Table [dbo].[TB_ProgramacaoAtendimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ProgramacaoAtendimento](
	[SequencialProgramacaoAtendimento] [int] IDENTITY(1,1) NOT NULL,
	[cd_associado] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[Programacao] [ntext] NOT NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[dt_alteracao] [datetime] NULL,
	[dt_exclusao] [datetime] NULL,
	[Programacao2] [ntext] NULL,
	[Programacao3] [ntext] NULL,
	[Programacao4] [ntext] NULL,
 CONSTRAINT [PK_TB_ProgramacaoAtendimento] PRIMARY KEY CLUSTERED 
(
	[SequencialProgramacaoAtendimento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_TB_ProgramacaoAtendimento] ON [dbo].[TB_ProgramacaoAtendimento]
(
	[cd_associado] ASC,
	[cd_sequencial_dep] ASC,
	[cd_funcionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
