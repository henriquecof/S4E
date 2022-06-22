/****** Object:  Table [dbo].[CRMGrupoResponsavel]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMGrupoResponsavel](
	[cgrId] [smallint] IDENTITY(1,1) NOT NULL,
	[cgrDescricao] [varchar](50) NOT NULL,
	[cgrDtCadastro] [datetime] NOT NULL,
	[UsuarioCadastro] [int] NOT NULL,
	[cgrDtExclusao] [datetime] NULL,
	[UsuarioExclusao] [int] NULL,
 CONSTRAINT [PK_CRMGrupoResponsavel] PRIMARY KEY CLUSTERED 
(
	[cgrId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_CRMGrupoResponsavel] ON [dbo].[CRMGrupoResponsavel]
(
	[cgrDtExclusao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CRMGrupoResponsavel]  WITH CHECK ADD  CONSTRAINT [FK_CRMGrupoResponsavel_FUNCIONARIO] FOREIGN KEY([UsuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[CRMGrupoResponsavel] CHECK CONSTRAINT [FK_CRMGrupoResponsavel_FUNCIONARIO]
ALTER TABLE [dbo].[CRMGrupoResponsavel]  WITH CHECK ADD  CONSTRAINT [FK_CRMGrupoResponsavel_FUNCIONARIO1] FOREIGN KEY([UsuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[CRMGrupoResponsavel] CHECK CONSTRAINT [FK_CRMGrupoResponsavel_FUNCIONARIO1]
