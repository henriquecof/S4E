/****** Object:  Table [dbo].[Departamento_Empresa]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Departamento_Empresa](
	[depId] [smallint] NOT NULL,
	[cd_empresa] [int] NOT NULL,
	[cd_orgao_demp] [varchar](10) NULL,
 CONSTRAINT [PK_Departamento_Empresa] PRIMARY KEY CLUSTERED 
(
	[depId] ASC,
	[cd_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Departamento_Empresa]  WITH CHECK ADD  CONSTRAINT [FK_Departamento_Empresa_Departamento] FOREIGN KEY([depId])
REFERENCES [dbo].[Departamento] ([depId])
ALTER TABLE [dbo].[Departamento_Empresa] CHECK CONSTRAINT [FK_Departamento_Empresa_Departamento]
