/****** Object:  Table [dbo].[TB_Revisao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Revisao](
	[sequencial] [int] IDENTITY(1,1) NOT NULL,
	[operacao] [smallint] NULL,
	[cd_servico] [int] NULL,
	[cd_associado] [int] NULL,
	[CD_Sequencial_Dep] [int] NULL,
	[ChavePrimaria] [int] NULL,
	[Data_Revisao] [datetime] NULL,
 CONSTRAINT [PK_TB_Revisao] PRIMARY KEY CLUSTERED 
(
	[sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
