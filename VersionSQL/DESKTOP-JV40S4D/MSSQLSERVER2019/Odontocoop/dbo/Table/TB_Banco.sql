/****** Object:  Table [dbo].[TB_Banco]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Banco](
	[Sequencial_Banco] [int] IDENTITY(1,1) NOT NULL,
	[Codigo_Banco] [int] NOT NULL,
	[Nome_Banco] [varchar](80) NOT NULL,
	[nome_usuario] [varchar](20) NULL,
 CONSTRAINT [PK_TB_Banco_Fin] PRIMARY KEY CLUSTERED 
(
	[Sequencial_Banco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [IX_TB_Banco] ON [dbo].[TB_Banco]
(
	[Codigo_Banco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE UNIQUE NONCLUSTERED INDEX [IX_TB_Banco_Fin] ON [dbo].[TB_Banco]
(
	[Codigo_Banco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Banco', @level2type=N'COLUMN',@level2name=N'Sequencial_Banco'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Código do banco|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Banco', @level2type=N'COLUMN',@level2name=N'Codigo_Banco'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nome do banco|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Banco', @level2type=N'COLUMN',@level2name=N'Nome_Banco'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nome do usuário|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Banco', @level2type=N'COLUMN',@level2name=N'nome_usuario'
