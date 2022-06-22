/****** Object:  Table [dbo].[tabela_referencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tabela_referencia](
	[cd_tabela_referencia] [int] IDENTITY(1,1) NOT NULL,
	[cd_tabela] [int] NOT NULL,
	[dt_inicio] [date] NOT NULL,
	[dt_fim] [date] NULL,
	[percentual_reajuste] [smallmoney] NULL,
	[valor_reajuste] [float] NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[protocolo] [varchar](50) NULL,
 CONSTRAINT [PK_tabela_referencia] PRIMARY KEY CLUSTERED 
(
	[cd_tabela_referencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_tabela_referencia] ON [dbo].[tabela_referencia]
(
	[protocolo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tabela_referencia_1] ON [dbo].[tabela_referencia]
(
	[dt_inicio] DESC,
	[cd_tabela_referencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[tabela_referencia]  WITH CHECK ADD  CONSTRAINT [FK_tabela_referencia_Tabela] FOREIGN KEY([cd_tabela])
REFERENCES [dbo].[Tabela] ([cd_tabela])
ALTER TABLE [dbo].[tabela_referencia] CHECK CONSTRAINT [FK_tabela_referencia_Tabela]
