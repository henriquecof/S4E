/****** Object:  Table [dbo].[TB_AgendamentoVendaContrato]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_AgendamentoVendaContrato](
	[sequencial_agendamento] [int] IDENTITY(1,1) NOT NULL,
	[data_horaagendamento] [datetime] NOT NULL,
	[Endereco_contrato] [varchar](500) NOT NULL,
	[Reagendamento] [smallint] NOT NULL,
	[Status] [smallint] NOT NULL,
	[cd_associado] [int] NOT NULL,
	[Forma_pagamento_Adesao] [smallint] NOT NULL,
	[usuario_inclusao] [varchar](20) NULL,
	[data_horainclusao] [datetime] NULL,
	[usuario_status] [varchar](20) NULL,
	[data_horastatus] [datetime] NULL,
	[Adesao] [smallint] NOT NULL,
	[Tipo_Contrato] [smallint] NOT NULL,
	[sequencial_sop] [int] NULL,
	[cd_sequencial_dep] [smallint] NULL,
	[carencia] [smallint] NULL,
	[nr_contrato] [varchar](20) NULL,
	[data_horaimpressao] [datetime] NULL,
	[Carteira_Impressa] [smallint] NULL,
 CONSTRAINT [PK_TB_AgendamentoVendaContrato] PRIMARY KEY CLUSTERED 
(
	[sequencial_agendamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_AgendamentoVendaContrato]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_AgendamentoVendaContrato_ASSOCIADOS] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[TB_AgendamentoVendaContrato] CHECK CONSTRAINT [FK_TB_AgendamentoVendaContrato_ASSOCIADOS]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 - Esperando Fechamento Contrato;2 - Contrato Fechado;3 - Venda Excluida' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_AgendamentoVendaContrato', @level2type=N'COLUMN',@level2name=N'Status'
