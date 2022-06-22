/****** Object:  Table [dbo].[SITUACAO_HISTORICO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SITUACAO_HISTORICO](
	[CD_SITUACAO_HISTORICO] [smallint] IDENTITY(1,1) NOT NULL,
	[NM_SITUACAO_HISTORICO] [nvarchar](50) NOT NULL,
	[fl_gera_cobranca] [bit] NOT NULL,
	[fl_envia_cobranca] [bit] NOT NULL,
	[fl_atendido_clinica] [bit] NOT NULL,
	[fl_incluir_ans] [bit] NOT NULL,
	[cd_motivo_exclusao_ans] [smallint] NULL,
	[dt_exclusao] [datetime] NULL,
	[fl_emite_NF] [bit] NOT NULL,
	[fl_aceitaVenda] [bit] NULL,
	[observacao] [varchar](500) NULL,
	[fl_motivoCancelamento] [bit] NULL,
	[fl_dataFimAtendimento] [bit] NULL,
	[fl_gera_carteira] [bit] NULL,
	[fl_acorda_parcelas] [bit] NULL,
	[exibeBuscaPrestadores] [bit] NULL,
	[verificacaoParcelasAtendimento] [bit] NULL,
 CONSTRAINT [PK_SITUACAO_HISTORICO_1] PRIMARY KEY NONCLUSTERED 
(
	[CD_SITUACAO_HISTORICO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SITUACAO_HISTORICO] ADD  CONSTRAINT [DF_SITUACAO_HISTORICO_fl_emite_NF_1]  DEFAULT ((0)) FOR [fl_emite_NF]
ALTER TABLE [dbo].[SITUACAO_HISTORICO]  WITH NOCHECK ADD  CONSTRAINT [FK_SITUACAO_HISTORICO_motivo_exclusao_ans] FOREIGN KEY([cd_motivo_exclusao_ans])
REFERENCES [dbo].[motivo_exclusao_ans] ([cd_motivo_exclusao_ans])
ALTER TABLE [dbo].[SITUACAO_HISTORICO] CHECK CONSTRAINT [FK_SITUACAO_HISTORICO_motivo_exclusao_ans]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Situação Historico' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SITUACAO_HISTORICO', @level2type=N'COLUMN',@level2name=N'CD_SITUACAO_HISTORICO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Situação Historico|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SITUACAO_HISTORICO', @level2type=N'COLUMN',@level2name=N'NM_SITUACAO_HISTORICO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gera Cobrança|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SITUACAO_HISTORICO', @level2type=N'COLUMN',@level2name=N'fl_gera_cobranca'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Envia Cobrança|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SITUACAO_HISTORICO', @level2type=N'COLUMN',@level2name=N'fl_envia_cobranca'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Atendido Clinica|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SITUACAO_HISTORICO', @level2type=N'COLUMN',@level2name=N'fl_atendido_clinica'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Incluir ANS|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SITUACAO_HISTORICO', @level2type=N'COLUMN',@level2name=N'fl_incluir_ans'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Motivo de exclusão ANS|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SITUACAO_HISTORICO', @level2type=N'COLUMN',@level2name=N'cd_motivo_exclusao_ans'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data de exclusão|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SITUACAO_HISTORICO', @level2type=N'COLUMN',@level2name=N'dt_exclusao'
