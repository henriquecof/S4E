/****** Object:  Table [dbo].[CRMMotivoDetalhado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMMotivoDetalhado](
	[mdeId] [smallint] IDENTITY(1,1) NOT NULL,
	[mdeDescricao] [varchar](100) NOT NULL,
	[motId] [smallint] NOT NULL,
	[mdeAtivo] [bit] NOT NULL,
	[Usuario] [int] NULL,
	[mdeTempoMinutoResposta] [int] NOT NULL,
	[mdeRespostaPadrao] [varchar](1000) NULL,
	[mdeInterno] [bit] NOT NULL,
	[tsrId] [tinyint] NULL,
	[mdeQtDiasNovaCampanha] [smallint] NULL,
	[mdeAgendamento] [bit] NULL,
	[mdeMalaDireta] [bit] NULL,
	[mdeADM] [bit] NULL,
	[mdeQtRenitencia] [tinyint] NULL,
	[cd_tipo_campanha] [smallint] NULL,
	[cgrId] [smallint] NULL,
	[mdeComissaoPagamento] [bit] NULL,
	[mdeREA] [bit] NULL,
	[rtiId] [tinyint] NULL,
	[rteId] [tinyint] NULL,
 CONSTRAINT [PK_CRMMotivoDetalhado] PRIMARY KEY CLUSTERED 
(
	[mdeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_CRMMotivoDetalhado] ON [dbo].[CRMMotivoDetalhado]
(
	[motId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_CRMMotivoDetalhado_1] ON [dbo].[CRMMotivoDetalhado]
(
	[mdeDescricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CRMMotivoDetalhado_2] ON [dbo].[CRMMotivoDetalhado]
(
	[tsrId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CRMMotivoDetalhado]  WITH CHECK ADD  CONSTRAINT [FK_CRMMotivoDetalhado_CRMGrupoResposanvel] FOREIGN KEY([cgrId])
REFERENCES [dbo].[CRMGrupoResponsavel] ([cgrId])
ALTER TABLE [dbo].[CRMMotivoDetalhado] CHECK CONSTRAINT [FK_CRMMotivoDetalhado_CRMGrupoResposanvel]
ALTER TABLE [dbo].[CRMMotivoDetalhado]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMMotivoDetalhado_CRMMotivo] FOREIGN KEY([motId])
REFERENCES [dbo].[CRMMotivo] ([motId])
ALTER TABLE [dbo].[CRMMotivoDetalhado] CHECK CONSTRAINT [FK_CRMMotivoDetalhado_CRMMotivo]
ALTER TABLE [dbo].[CRMMotivoDetalhado]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMMotivoDetalhado_CRMTipoStatusResultado] FOREIGN KEY([tsrId])
REFERENCES [dbo].[CRMTipoStatusResultado] ([tsrId])
ALTER TABLE [dbo].[CRMMotivoDetalhado] CHECK CONSTRAINT [FK_CRMMotivoDetalhado_CRMTipoStatusResultado]
ALTER TABLE [dbo].[CRMMotivoDetalhado]  WITH CHECK ADD  CONSTRAINT [FK_CRMMotivoDetalhado_Tipo_Campanha] FOREIGN KEY([cd_tipo_campanha])
REFERENCES [dbo].[Tipo_Campanha] ([cd_tipo_campanha])
ALTER TABLE [dbo].[CRMMotivoDetalhado] CHECK CONSTRAINT [FK_CRMMotivoDetalhado_Tipo_Campanha]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Descrição|&' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRMMotivoDetalhado', @level2type=N'COLUMN',@level2name=N'mdeDescricao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo CRMMotivo|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRMMotivoDetalhado', @level2type=N'COLUMN',@level2name=N'motId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ativo|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRMMotivoDetalhado', @level2type=N'COLUMN',@level2name=N'mdeAtivo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Usuario|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CRMMotivoDetalhado', @level2type=N'COLUMN',@level2name=N'Usuario'
