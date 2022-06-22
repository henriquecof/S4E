/****** Object:  Table [dbo].[GrupoCarencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoCarencia](
	[idGrupoCarencia] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [varchar](50) NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
 CONSTRAINT [PK_GrupoCarencia] PRIMARY KEY CLUSTERED 
(
	[idGrupoCarencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[GrupoCarencia]  WITH CHECK ADD  CONSTRAINT [FK_GrupoCarencia_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[GrupoCarencia] CHECK CONSTRAINT [FK_GrupoCarencia_FUNCIONARIO]
ALTER TABLE [dbo].[GrupoCarencia]  WITH CHECK ADD  CONSTRAINT [FK_GrupoCarencia_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[GrupoCarencia] CHECK CONSTRAINT [FK_GrupoCarencia_FUNCIONARIO1]
