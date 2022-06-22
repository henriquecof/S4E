/****** Object:  Table [dbo].[GrupoProcedimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoProcedimento](
	[gprId] [smallint] IDENTITY(1,1) NOT NULL,
	[gprDescricao] [varchar](100) NULL,
	[cd_centro_custo] [smallint] NOT NULL,
	[gprDtCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[gprDtExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
 CONSTRAINT [PK_GrupoProcedimento] PRIMARY KEY CLUSTERED 
(
	[gprId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_GrupoProcedimento] ON [dbo].[GrupoProcedimento]
(
	[cd_centro_custo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[GrupoProcedimento]  WITH CHECK ADD  CONSTRAINT [FK_GrupoProcedimento_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[GrupoProcedimento] CHECK CONSTRAINT [FK_GrupoProcedimento_Centro_Custo]
