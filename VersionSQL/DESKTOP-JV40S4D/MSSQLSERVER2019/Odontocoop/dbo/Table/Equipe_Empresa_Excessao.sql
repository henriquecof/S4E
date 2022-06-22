/****** Object:  Table [dbo].[Equipe_Empresa_Excessao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Equipe_Empresa_Excessao](
	[cd_equipe] [smallint] NOT NULL,
	[cd_empresa] [int] NOT NULL,
 CONSTRAINT [PK_EquipeVendas_Empresa_Excessao] PRIMARY KEY CLUSTERED 
(
	[cd_equipe] ASC,
	[cd_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Equipe_Empresa_Excessao]  WITH CHECK ADD  CONSTRAINT [FK_Equipe_Empresa_Excessao_equipe_vendas] FOREIGN KEY([cd_equipe])
REFERENCES [dbo].[equipe_vendas] ([cd_equipe])
ALTER TABLE [dbo].[Equipe_Empresa_Excessao] CHECK CONSTRAINT [FK_Equipe_Empresa_Excessao_equipe_vendas]
