/****** Object:  Table [dbo].[Lote_Processos_Bancos_Retorno]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_Processos_Bancos_Retorno](
	[cd_sequencial_retorno] [int] IDENTITY(1,1) NOT NULL,
	[cd_tipo_servico_bancario] [smallint] NULL,
	[cd_tipo_pagamento] [int] NULL,
	[dt_processado] [datetime] NOT NULL,
	[nsa] [int] NULL,
	[convenio] [varchar](20) NULL,
	[nm_arquivo] [varchar](100) NOT NULL,
	[obs] [varchar](200) NOT NULL,
	[qtde] [int] NULL,
	[valor] [money] NULL,
	[EnviarEmailBoleto] [bit] NULL,
	[DataEnvioEmailBoleto] [datetime] NULL,
 CONSTRAINT [PK_Lote_Processos_Bancos_Retorno] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_retorno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Lote_Processos_Bancos_Retorno] ON [dbo].[Lote_Processos_Bancos_Retorno]
(
	[cd_tipo_pagamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Lote_Processos_Bancos_Retorno_1] ON [dbo].[Lote_Processos_Bancos_Retorno]
(
	[cd_tipo_servico_bancario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Lote_Processos_Bancos_Retorno]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_Processos_Bancos_Retorno_tipo_servico_bancario] FOREIGN KEY([cd_tipo_servico_bancario])
REFERENCES [dbo].[tipo_servico_bancario] ([cd_tipo_servico_bancario])
ALTER TABLE [dbo].[Lote_Processos_Bancos_Retorno] CHECK CONSTRAINT [FK_Lote_Processos_Bancos_Retorno_tipo_servico_bancario]
