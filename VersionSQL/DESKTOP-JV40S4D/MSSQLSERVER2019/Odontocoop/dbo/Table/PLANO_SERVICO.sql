/****** Object:  Table [dbo].[PLANO_SERVICO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PLANO_SERVICO](
	[cd_plano] [int] NOT NULL,
	[cd_servico] [int] NOT NULL,
	[id_coparticipacao] [bit] NOT NULL,
	[qt_diascarencia] [smallint] NULL,
	[fl_exclusivo] [bit] NULL,
	[tipoPagamentoFranquia] [tinyint] NULL,
	[valorPagamentoFranquia] [money] NULL,
 CONSTRAINT [PK_PLANO_SERVICO] PRIMARY KEY NONCLUSTERED 
(
	[cd_plano] ASC,
	[cd_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_PLANO_SERVICO] ON [dbo].[PLANO_SERVICO]
(
	[cd_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_PLANO_SERVICO_1] ON [dbo].[PLANO_SERVICO]
(
	[cd_plano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[PLANO_SERVICO]  WITH NOCHECK ADD  CONSTRAINT [FK_PLANO_SERVICO_PLANOS] FOREIGN KEY([cd_plano])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[PLANO_SERVICO] CHECK CONSTRAINT [FK_PLANO_SERVICO_PLANOS]
ALTER TABLE [dbo].[PLANO_SERVICO]  WITH NOCHECK ADD  CONSTRAINT [FK_PLANO_SERVICO_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[PLANO_SERVICO] CHECK CONSTRAINT [FK_PLANO_SERVICO_SERVICO]
