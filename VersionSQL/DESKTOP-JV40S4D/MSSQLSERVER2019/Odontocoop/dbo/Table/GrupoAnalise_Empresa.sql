/****** Object:  Table [dbo].[GrupoAnalise_Empresa]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoAnalise_Empresa](
	[CD_GRUPOAnalise] [smallint] NOT NULL,
	[CD_EMPRESA] [bigint] NOT NULL,
 CONSTRAINT [PK_GrupoEmpresa] PRIMARY KEY CLUSTERED 
(
	[CD_GRUPOAnalise] ASC,
	[CD_EMPRESA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[GrupoAnalise_Empresa]  WITH CHECK ADD  CONSTRAINT [FK_GrupoAnalise_Empresa_EMPRESA] FOREIGN KEY([CD_EMPRESA])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[GrupoAnalise_Empresa] CHECK CONSTRAINT [FK_GrupoAnalise_Empresa_EMPRESA]
ALTER TABLE [dbo].[GrupoAnalise_Empresa]  WITH CHECK ADD  CONSTRAINT [FK_GrupoAnalise_Empresa_GrupoAnalise] FOREIGN KEY([CD_GRUPOAnalise])
REFERENCES [dbo].[GrupoAnalise] ([CD_GRUPOAnalise])
ALTER TABLE [dbo].[GrupoAnalise_Empresa] CHECK CONSTRAINT [FK_GrupoAnalise_Empresa_GrupoAnalise]
