/****** Object:  Table [dbo].[ParametroOpcao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ParametroOpcao](
	[id] [int] NOT NULL,
	[nome] [varchar](500) NOT NULL,
	[parametroId] [int] NOT NULL,
 CONSTRAINT [PK_ParametroOpcao] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ParametroOpcao]  WITH CHECK ADD  CONSTRAINT [FK_ParametroOpcao_Parametro] FOREIGN KEY([parametroId])
REFERENCES [dbo].[Parametro] ([id])
ALTER TABLE [dbo].[ParametroOpcao] CHECK CONSTRAINT [FK_ParametroOpcao_Parametro]
