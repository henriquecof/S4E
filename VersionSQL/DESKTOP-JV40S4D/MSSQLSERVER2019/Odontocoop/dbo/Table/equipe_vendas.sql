/****** Object:  Table [dbo].[equipe_vendas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[equipe_vendas](
	[cd_equipe] [smallint] IDENTITY(1,1) NOT NULL,
	[nm_equipe] [varchar](50) NOT NULL,
	[cd_chefe] [int] NULL,
	[cd_centro_custo] [smallint] NULL,
	[cd_chefe1] [int] NULL,
	[cd_chefe2] [int] NULL,
	[cd_chefe3] [int] NULL,
	[cd_chefe4] [int] NULL,
 CONSTRAINT [PK_equipe_vendas] PRIMARY KEY NONCLUSTERED 
(
	[cd_equipe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[equipe_vendas]  WITH NOCHECK ADD  CONSTRAINT [FK_equipe_vendas_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[equipe_vendas] CHECK CONSTRAINT [FK_equipe_vendas_Centro_Custo]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'equipe_vendas', @level2type=N'COLUMN',@level2name=N'cd_equipe'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Equipe' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'equipe_vendas', @level2type=N'COLUMN',@level2name=N'nm_equipe'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Coordenador' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'equipe_vendas', @level2type=N'COLUMN',@level2name=N'cd_chefe'
