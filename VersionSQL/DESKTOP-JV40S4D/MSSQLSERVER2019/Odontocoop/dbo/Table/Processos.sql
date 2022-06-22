/****** Object:  Table [dbo].[Processos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Processos](
	[cd_processo] [smallint] NOT NULL,
	[ds_processo] [varchar](50) NOT NULL,
	[mdeId] [smallint] NULL,
	[cd_funcionario] [int] NULL,
	[ds_procedure] [varchar](50) NULL,
 CONSTRAINT [PK_Processos] PRIMARY KEY CLUSTERED 
(
	[cd_processo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Processo|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Processos', @level2type=N'COLUMN',@level2name=N'ds_processo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detalhado|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Processos', @level2type=N'COLUMN',@level2name=N'mdeId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Funcionario|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Processos', @level2type=N'COLUMN',@level2name=N'cd_funcionario'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Procedure|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Processos', @level2type=N'COLUMN',@level2name=N'ds_procedure'
