/****** Object:  Table [dbo].[ProtocoloConsultas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ProtocoloConsultas](
	[id_protocolo] [int] IDENTITY(1,1) NOT NULL,
	[dt_gerado] [datetime] NOT NULL,
	[dt_alterado] [datetime] NULL,
	[dt_recebido] [datetime] NULL,
	[usuario_recebimento] [int] NULL,
	[usuario_cadastro] [int] NULL,
	[cd_funcionario] [int] NULL,
	[cd_filial] [int] NULL,
	[dt_exclusao] [datetime] NULL,
	[usuario_exclusao] [int] NULL,
	[dt_impresso] [datetime] NULL,
	[usuario_impressao] [int] NULL,
	[GTODigital] [tinyint] NULL,
	[sequencialVersao] [smallint] NULL,
	[usuarioVersao] [int] NULL,
	[lotePagamentoDentista] [int] NULL,
	[protocoloPadronizado] [varchar](20) NULL,
 CONSTRAINT [PK_ProtocoloConsultas] PRIMARY KEY CLUSTERED 
(
	[id_protocolo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_ProtocoloConsultas] ON [dbo].[ProtocoloConsultas]
(
	[dt_gerado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[ProtocoloConsultas]  WITH CHECK ADD  CONSTRAINT [FK_ProtocoloConsultas_Filial] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[ProtocoloConsultas] CHECK CONSTRAINT [FK_ProtocoloConsultas_Filial]
ALTER TABLE [dbo].[ProtocoloConsultas]  WITH CHECK ADD  CONSTRAINT [FK_ProtocoloConsultas_pagamento_dentista] FOREIGN KEY([lotePagamentoDentista])
REFERENCES [dbo].[pagamento_dentista] ([cd_sequencial])
ALTER TABLE [dbo].[ProtocoloConsultas] CHECK CONSTRAINT [FK_ProtocoloConsultas_pagamento_dentista]
