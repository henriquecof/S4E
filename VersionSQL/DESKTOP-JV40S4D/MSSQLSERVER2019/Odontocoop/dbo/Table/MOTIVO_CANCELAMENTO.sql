/****** Object:  Table [dbo].[MOTIVO_CANCELAMENTO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MOTIVO_CANCELAMENTO](
	[cd_motivo_cancelamento] [int] IDENTITY(1,1) NOT NULL,
	[nm_motivo_cancelamento] [varchar](100) NOT NULL,
	[tp_valido_associado] [bit] NOT NULL,
	[tp_valido_empresa] [bit] NOT NULL,
	[cd_motivo_exclusao_ans] [smallint] NOT NULL,
	[tp_valido_associado_pj] [bit] NOT NULL,
	[tp_valido_portal] [bit] NULL,
 CONSTRAINT [PK_MOTIVO_CANCELAMENTO] PRIMARY KEY NONCLUSTERED 
(
	[cd_motivo_cancelamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[MOTIVO_CANCELAMENTO] ADD  CONSTRAINT [DF_MOTIVO_CANCELAMENTO_tp_valido_associado_pf]  DEFAULT ((0)) FOR [tp_valido_associado_pj]
ALTER TABLE [dbo].[MOTIVO_CANCELAMENTO]  WITH NOCHECK ADD  CONSTRAINT [FK_MOTIVO_CANCELAMENTO_motivo_exclusao_ans] FOREIGN KEY([cd_motivo_exclusao_ans])
REFERENCES [dbo].[motivo_exclusao_ans] ([cd_motivo_exclusao_ans])
ALTER TABLE [dbo].[MOTIVO_CANCELAMENTO] CHECK CONSTRAINT [FK_MOTIVO_CANCELAMENTO_motivo_exclusao_ans]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Motivo Cancelamento|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MOTIVO_CANCELAMENTO', @level2type=N'COLUMN',@level2name=N'nm_motivo_cancelamento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valido Associado|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MOTIVO_CANCELAMENTO', @level2type=N'COLUMN',@level2name=N'tp_valido_associado'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valido Empresa|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MOTIVO_CANCELAMENTO', @level2type=N'COLUMN',@level2name=N'tp_valido_empresa'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Motivo de exclusão ANS|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MOTIVO_CANCELAMENTO', @level2type=N'COLUMN',@level2name=N'cd_motivo_exclusao_ans'
