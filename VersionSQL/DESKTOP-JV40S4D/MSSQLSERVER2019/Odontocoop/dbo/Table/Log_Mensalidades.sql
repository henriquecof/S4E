/****** Object:  Table [dbo].[Log_Mensalidades]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Log_Mensalidades](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[CD_ASSOCIADO_empresa] [int] NOT NULL,
	[TP_ASSOCIADO_EMPRESA] [smallint] NOT NULL,
	[CD_TIPO_PAGAMENTO] [int] NOT NULL,
	[dt_gerado] [datetime] NOT NULL,
	[DT_VENCIMENTO] [datetime] NOT NULL,
	[cd_statusLog] [smallint] NOT NULL,
	[obs] [varchar](200) NULL,
	[fl_regerado] [bit] NOT NULL,
	[vl_fatura] [money] NOT NULL,
	[cd_parcela] [int] NULL,
 CONSTRAINT [PK_Log_Mensalidades] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Log_Mensalidades] ADD  CONSTRAINT [DF_Log_Mensalidades_fl_regerado]  DEFAULT ((0)) FOR [fl_regerado]
ALTER TABLE [dbo].[Log_Mensalidades] ADD  CONSTRAINT [DF_Log_Mensalidades_vl_fatura]  DEFAULT ((0)) FOR [vl_fatura]
ALTER TABLE [dbo].[Log_Mensalidades]  WITH NOCHECK ADD  CONSTRAINT [FK_Log_Mensalidades_Status_LogMensalidades] FOREIGN KEY([cd_statusLog])
REFERENCES [dbo].[Status_LogMensalidades] ([cd_statusLog])
ALTER TABLE [dbo].[Log_Mensalidades] CHECK CONSTRAINT [FK_Log_Mensalidades_Status_LogMensalidades]
ALTER TABLE [dbo].[Log_Mensalidades]  WITH NOCHECK ADD  CONSTRAINT [FK_Log_Mensalidades_TIPO_ASSOCIADO_EMPRESA] FOREIGN KEY([TP_ASSOCIADO_EMPRESA])
REFERENCES [dbo].[TIPO_ASSOCIADO_EMPRESA] ([TP_ASSOCIADO_EMPRESA])
ALTER TABLE [dbo].[Log_Mensalidades] CHECK CONSTRAINT [FK_Log_Mensalidades_TIPO_ASSOCIADO_EMPRESA]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Código|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Log_Mensalidades', @level2type=N'COLUMN',@level2name=N'CD_ASSOCIADO_empresa'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Associado|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Log_Mensalidades', @level2type=N'COLUMN',@level2name=N'TP_ASSOCIADO_EMPRESA'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo Pagamento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Log_Mensalidades', @level2type=N'COLUMN',@level2name=N'CD_TIPO_PAGAMENTO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Gerado|&' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Log_Mensalidades', @level2type=N'COLUMN',@level2name=N'dt_gerado'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vencimento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Log_Mensalidades', @level2type=N'COLUMN',@level2name=N'DT_VENCIMENTO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Log_Mensalidades', @level2type=N'COLUMN',@level2name=N'cd_statusLog'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Obs' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Log_Mensalidades', @level2type=N'COLUMN',@level2name=N'obs'
