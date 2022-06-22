/****** Object:  Table [dbo].[TB_TermosLOG_TLo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_TermosLOG_TLo](
	[Sequencial_TLo] [int] IDENTITY(1,1) NOT NULL,
	[Sequencial_TTe] [int] NOT NULL,
	[cd_associado] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_servico] [int] NULL,
	[DescricaoServico_TLo] [varchar](200) NULL,
	[cd_funcionario] [int] NOT NULL,
	[DtInclusao_TLo] [datetime] NOT NULL,
 CONSTRAINT [PK_TB_TermosLOG_TLo] PRIMARY KEY CLUSTERED 
(
	[Sequencial_TLo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
