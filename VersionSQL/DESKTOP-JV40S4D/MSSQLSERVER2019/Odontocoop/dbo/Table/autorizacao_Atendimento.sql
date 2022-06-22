/****** Object:  Table [dbo].[autorizacao_Atendimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[autorizacao_Atendimento](
	[nr_autorizacao] [char](30) NOT NULL,
	[dt_solicitacao] [smalldatetime] NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[nm_motivo] [nvarchar](500) NULL,
	[cd_sequencial_dep] [int] NULL,
	[cd_lote_avulso] [int] NULL,
	[cd_filial] [smallint] NULL,
	[cd_funcionario_solicitacao] [int] NULL,
	[cd_usuario_autorizou] [nvarchar](50) NULL,
 CONSTRAINT [PK_autorizacao_Atendimento1] PRIMARY KEY NONCLUSTERED 
(
	[nr_autorizacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_autorizacao_Atendimento] ON [dbo].[autorizacao_Atendimento]
(
	[dt_solicitacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_autorizacao_Atendimento_1] ON [dbo].[autorizacao_Atendimento]
(
	[cd_funcionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
