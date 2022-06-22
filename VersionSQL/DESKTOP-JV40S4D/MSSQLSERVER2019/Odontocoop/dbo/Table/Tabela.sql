/****** Object:  Table [dbo].[Tabela]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tabela](
	[cd_tabela] [int] IDENTITY(1,1) NOT NULL,
	[ds_tabela] [varchar](100) NULL,
	[cd_centro_custo] [smallint] NULL,
 CONSTRAINT [PK_Tabela] PRIMARY KEY CLUSTERED 
(
	[cd_tabela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Tabela]  WITH NOCHECK ADD  CONSTRAINT [FK_Tabela_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[Tabela] CHECK CONSTRAINT [FK_Tabela_Centro_Custo]
