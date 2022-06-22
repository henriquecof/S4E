/****** Object:  Table [dbo].[TB_Pericia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Pericia](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_associado] [int] NOT NULL,
	[cd_sequencial_dep] [smallint] NOT NULL,
	[data_pericia] [datetime] NULL,
	[cd_funcionario] [int] NULL,
	[data_cadastro] [datetime] NOT NULL,
 CONSTRAINT [PK_TB_Pericia] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
