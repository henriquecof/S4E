/****** Object:  Table [dbo].[ParametroValor]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ParametroValor](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[parametroId] [int] NOT NULL,
	[parametroOpcaoId] [int] NULL,
	[valor] [varchar](5000) NOT NULL,
 CONSTRAINT [PK_ParametroValor] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ParametroValor]  WITH CHECK ADD  CONSTRAINT [FK_ParametroValor_Parametro] FOREIGN KEY([parametroId])
REFERENCES [dbo].[Parametro] ([id])
ALTER TABLE [dbo].[ParametroValor] CHECK CONSTRAINT [FK_ParametroValor_Parametro]
ALTER TABLE [dbo].[ParametroValor]  WITH CHECK ADD  CONSTRAINT [FK_ParametroValor_ParametroOpcao] FOREIGN KEY([parametroOpcaoId])
REFERENCES [dbo].[ParametroOpcao] ([id])
ALTER TABLE [dbo].[ParametroValor] CHECK CONSTRAINT [FK_ParametroValor_ParametroOpcao]
