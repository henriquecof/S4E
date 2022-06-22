/****** Object:  Table [dbo].[TB_ContaParametrizadasLancamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ContaParametrizadasLancamento](
	[cd_sequencial_para] [int] NOT NULL,
	[sequencial_lancamento] [int] NOT NULL,
	[dt_competencia] [datetime] NOT NULL,
	[dt_recebido] [datetime] NULL,
 CONSTRAINT [PK_TB_ContaParametrizadasLancamento] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_para] ASC,
	[sequencial_lancamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_ContaParametrizadasLancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_ContaParametrizadasLancamento_TB_ContaParametrizadas] FOREIGN KEY([cd_sequencial_para])
REFERENCES [dbo].[TB_ContaParametrizadas] ([cd_sequencial])
ALTER TABLE [dbo].[TB_ContaParametrizadasLancamento] CHECK CONSTRAINT [FK_TB_ContaParametrizadasLancamento_TB_ContaParametrizadas]
ALTER TABLE [dbo].[TB_ContaParametrizadasLancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_ContaParametrizadasLancamento_TB_Lancamento] FOREIGN KEY([sequencial_lancamento])
REFERENCES [dbo].[TB_Lancamento] ([Sequencial_Lancamento])
ALTER TABLE [dbo].[TB_ContaParametrizadasLancamento] CHECK CONSTRAINT [FK_TB_ContaParametrizadasLancamento_TB_Lancamento]
