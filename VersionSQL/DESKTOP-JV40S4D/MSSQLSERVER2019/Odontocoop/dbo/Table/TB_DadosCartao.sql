/****** Object:  Table [dbo].[TB_DadosCartao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_DadosCartao](
	[Sequencial_DadosCartao] [int] IDENTITY(1,1) NOT NULL,
	[Sequencial_cartao_car] [int] NOT NULL,
	[Codigo_OrigemCartao] [int] NOT NULL,
 CONSTRAINT [PK_TB_DadosCartao] PRIMARY KEY CLUSTERED 
(
	[Sequencial_DadosCartao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [IX_TB_DadosCartao] ON [dbo].[TB_DadosCartao]
(
	[Codigo_OrigemCartao] ASC,
	[Sequencial_cartao_car] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TB_DadosCartao]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_DadosCartao_TB_Cartao_Car] FOREIGN KEY([Sequencial_cartao_car])
REFERENCES [dbo].[TB_Cartao_Car] ([SequencialCartao_Car])
ALTER TABLE [dbo].[TB_DadosCartao] CHECK CONSTRAINT [FK_TB_DadosCartao_TB_Cartao_Car]
ALTER TABLE [dbo].[TB_DadosCartao]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_DadosCartao_TB_OrigemCartao] FOREIGN KEY([Codigo_OrigemCartao])
REFERENCES [dbo].[TB_OrigemCartao] ([Codigo_OrigemCartao])
ALTER TABLE [dbo].[TB_DadosCartao] CHECK CONSTRAINT [FK_TB_DadosCartao_TB_OrigemCartao]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SequencialDadosCartao' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_DadosCartao', @level2type=N'COLUMN',@level2name=N'Sequencial_DadosCartao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SequencialCartao' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_DadosCartao', @level2type=N'COLUMN',@level2name=N'Sequencial_cartao_car'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CodigoOrigemCartao' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_DadosCartao', @level2type=N'COLUMN',@level2name=N'Codigo_OrigemCartao'
