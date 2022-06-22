/****** Object:  Table [dbo].[CARGO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CARGO](
	[cd_cargo] [smallint] IDENTITY(1,1) NOT NULL,
	[nm_cargo] [varchar](50) NOT NULL,
	[fl_geracomissao] [bit] NULL,
	[fl_adesionista] [bit] NULL,
	[cd_grupocargo] [tinyint] NOT NULL,
	[grupoPermissaoId] [int] NULL,
	[aceitaLogin] [bit] NULL,
	[fl_repasse] [bit] NULL,
 CONSTRAINT [PK_CARGO] PRIMARY KEY NONCLUSTERED 
(
	[cd_cargo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CARGO] ADD  CONSTRAINT [DF_CARGO_cd_grupocargo]  DEFAULT ((1)) FOR [cd_grupocargo]
ALTER TABLE [dbo].[CARGO]  WITH CHECK ADD  CONSTRAINT [FK_CARGO_Grupo_Cargo] FOREIGN KEY([cd_grupocargo])
REFERENCES [dbo].[Grupo_Cargo] ([cd_grupocargo])
ALTER TABLE [dbo].[CARGO] CHECK CONSTRAINT [FK_CARGO_Grupo_Cargo]
ALTER TABLE [dbo].[CARGO]  WITH CHECK ADD  CONSTRAINT [FK_CARGO_GrupoFuncionario] FOREIGN KEY([grupoPermissaoId])
REFERENCES [dbo].[GrupoFuncionario] ([gfuId])
ALTER TABLE [dbo].[CARGO] CHECK CONSTRAINT [FK_CARGO_GrupoFuncionario]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cargo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CARGO', @level2type=N'COLUMN',@level2name=N'nm_cargo'
