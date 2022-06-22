/****** Object:  Table [dbo].[ESPECIALIDADE]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ESPECIALIDADE](
	[cd_especialidade] [int] IDENTITY(1,1) NOT NULL,
	[nm_especialidade] [nvarchar](30) NOT NULL,
	[fl_ortodontia] [bit] NULL,
	[fl_autoriza_atend_automatico] [bit] NULL,
	[cd_termo] [smallint] NULL,
	[fl_contabiliza_marcacao] [bit] NOT NULL,
	[idade_maxima] [tinyint] NULL,
	[qt_dias_prox_atendimento] [tinyint] NULL,
	[fl_radiologia] [bit] NULL,
	[fl_AceitaInconsistente] [bit] NULL,
	[fl_marcacao_web] [bit] NULL,
	[ordem_prioridade_marc_web] [smallint] NULL,
	[fl_avaliadignostico_regra34] [bit] NULL,
	[valorDescontoMax] [money] NULL,
	[fl_ExibirRedeAtendimento] [bit] NULL,
	[fl_AceitaSemCobertura] [bit] NULL,
	[fl_diagnostico] [bit] NULL,
	[fl_urgencia] [bit] NULL,
	[codigoContaFinanceira] [varchar](4) NULL,
	[fl_odontograma_resumido] [bit] NULL,
	[fl_odontograma_situacao_inicial] [bit] NULL,
	[nomeComercialEspecialidade] [varchar](60) NULL,
	[permiteRemarcacao] [bit] NULL,
	[cd_ramo_atividade] [int] NULL,
	[fl_periciafinal] [bit] NULL,
 CONSTRAINT [PK_ESPECIALIDADE] PRIMARY KEY NONCLUSTERED 
(
	[cd_especialidade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Especialidade_RamoAtividade] ON [dbo].[ESPECIALIDADE]
(
	[cd_ramo_atividade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Especialidade' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ESPECIALIDADE', @level2type=N'COLUMN',@level2name=N'nm_especialidade'
