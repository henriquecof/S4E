/****** Object:  Table [dbo].[ProducaoDentistaMovimentacaoDeCredito]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ProducaoDentistaMovimentacaoDeCredito](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dataAgenda] [datetime] NOT NULL,
	[idDentista] [int] NOT NULL,
	[idFilial] [int] NOT NULL,
	[valor] [money] NOT NULL,
	[tipoMovimento] [tinyint] NOT NULL,
	[dataCadastro] [datetime] NULL,
	[usuarioCadastro] [int] NULL,
	[dataExclusao] [datetime] NULL,
	[usuarioExclusao] [int] NULL,
	[Sequencial_Lancamento] [int] NULL,
 CONSTRAINT [PK_ProducaoDentistaMovimentacaoDeCredito] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProducaoDentistaMovimentacaoDeCredito]  WITH CHECK ADD  CONSTRAINT [FK_ProducaoDentistaMovimentacaoDeCredito_FILIAL] FOREIGN KEY([idFilial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[ProducaoDentistaMovimentacaoDeCredito] CHECK CONSTRAINT [FK_ProducaoDentistaMovimentacaoDeCredito_FILIAL]
ALTER TABLE [dbo].[ProducaoDentistaMovimentacaoDeCredito]  WITH CHECK ADD  CONSTRAINT [FK_ProducaoDentistaMovimentacaoDeCredito_TB_Lancamento] FOREIGN KEY([Sequencial_Lancamento])
REFERENCES [dbo].[TB_Lancamento] ([Sequencial_Lancamento])
ALTER TABLE [dbo].[ProducaoDentistaMovimentacaoDeCredito] CHECK CONSTRAINT [FK_ProducaoDentistaMovimentacaoDeCredito_TB_Lancamento]
