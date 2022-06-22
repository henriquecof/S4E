/****** Object:  Table [dbo].[Categoria_Ans]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Categoria_Ans](
	[cd_categoria_ans] [smallint] NOT NULL,
	[nm_categoria_ans] [varchar](200) NOT NULL,
	[cd_codigo_ans] [varchar](50) NULL,
	[ordem] [smallint] NOT NULL,
	[padrao_idade] [smallint] NOT NULL,
	[UD_Inicial] [smallint] NULL,
	[UD_Final] [smallint] NULL,
	[peso] [smallint] NULL,
 CONSTRAINT [PK_Categoria_Ans] PRIMARY KEY CLUSTERED 
(
	[cd_categoria_ans] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0-Todos,1-12 anos ou mais e 2-Menor de 12 anos' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Categoria_Ans', @level2type=N'COLUMN',@level2name=N'padrao_idade'
