/****** Object:  Table [dbo].[TB_Banco_Contratos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Banco_Contratos](
	[cd_banco] [int] NOT NULL,
	[nm_banco] [varchar](50) NOT NULL,
	[fl_ativo] [bit] NOT NULL,
 CONSTRAINT [PK_TB_Banco] PRIMARY KEY CLUSTERED 
(
	[cd_banco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_Banco_Contratos] ADD  CONSTRAINT [DF_TB_Banco_fl_ativo]  DEFAULT ((0)) FOR [fl_ativo]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Código|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Banco_Contratos', @level2type=N'COLUMN',@level2name=N'cd_banco'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nome|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Banco_Contratos', @level2type=N'COLUMN',@level2name=N'nm_banco'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ativo|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Banco_Contratos', @level2type=N'COLUMN',@level2name=N'fl_ativo'
