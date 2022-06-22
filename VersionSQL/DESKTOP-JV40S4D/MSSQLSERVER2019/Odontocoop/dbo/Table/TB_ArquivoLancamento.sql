/****** Object:  Table [dbo].[TB_ArquivoLancamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ArquivoLancamento](
	[arlId] [int] IDENTITY(1,1) NOT NULL,
	[Sequencial_Lancamento] [int] NOT NULL,
	[arlUsuExclusao] [int] NULL,
	[arlDtExclusao] [datetime] NULL,
	[arlNome] [varchar](50) NOT NULL,
	[arlExtensao] [varchar](5) NOT NULL,
	[arlUsuInclusao] [int] NULL,
	[arlDtInclusao] [datetime] NULL,
 CONSTRAINT [PK_TB_ArquivoLancamento] PRIMARY KEY CLUSTERED 
(
	[arlId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_ArquivoLancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_ArquivoLancamento_TB_Lancamento] FOREIGN KEY([Sequencial_Lancamento])
REFERENCES [dbo].[TB_Lancamento] ([Sequencial_Lancamento])
ALTER TABLE [dbo].[TB_ArquivoLancamento] CHECK CONSTRAINT [FK_TB_ArquivoLancamento_TB_Lancamento]
