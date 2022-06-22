/****** Object:  Table [dbo].[Modelo_Pagamento_Prestador]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Modelo_Pagamento_Prestador](
	[cd_modelo_pgto_prestador] [smallint] IDENTITY(1,1) NOT NULL,
	[ds_modelo_pgto_prestador] [varchar](50) NOT NULL,
	[cd_tipo_faturamento] [tinyint] NOT NULL,
	[id_contabilizado] [bit] NOT NULL,
	[fl_ativo] [bit] NOT NULL,
	[cd_conta] [int] NOT NULL,
	[sequencial_movimentacao] [int] NOT NULL,
	[sequencial_TTE] [int] NULL,
 CONSTRAINT [PK_Modelo_Pagamento_Prestador] PRIMARY KEY CLUSTERED 
(
	[cd_modelo_pgto_prestador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Modelo_Pagamento_Prestador]  WITH NOCHECK ADD  CONSTRAINT [FK_Modelo_Pagamento_Prestador_TB_TermosTextos_TTe] FOREIGN KEY([sequencial_TTE])
REFERENCES [dbo].[TB_TermosTextos_TTe] ([Sequencial_TTe])
ALTER TABLE [dbo].[Modelo_Pagamento_Prestador] CHECK CONSTRAINT [FK_Modelo_Pagamento_Prestador_TB_TermosTextos_TTe]
ALTER TABLE [dbo].[Modelo_Pagamento_Prestador]  WITH NOCHECK ADD  CONSTRAINT [FK_Modelo_Pagamento_Prestador_Tipo_Faturamento] FOREIGN KEY([cd_tipo_faturamento])
REFERENCES [dbo].[Tipo_Faturamento] ([cd_tipo_faturamento])
ALTER TABLE [dbo].[Modelo_Pagamento_Prestador] CHECK CONSTRAINT [FK_Modelo_Pagamento_Prestador_Tipo_Faturamento]
