/****** Object:  Table [dbo].[ImportarUsuariosCancelamentoRegistros]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ImportarUsuariosCancelamentoRegistros](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[dataProcessado] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ImportarUsuariosCancelamentoRegistros]  WITH CHECK ADD  CONSTRAINT [FK_Dependentes_cd_sequencial_ImportarUsuariosCancelamentoRegistros_cd_sequencial_dep] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[ImportarUsuariosCancelamentoRegistros] CHECK CONSTRAINT [FK_Dependentes_cd_sequencial_ImportarUsuariosCancelamentoRegistros_cd_sequencial_dep]
ALTER TABLE [dbo].[ImportarUsuariosCancelamentoRegistros]  WITH CHECK ADD  CONSTRAINT [FK_Funcionario_cd_funcionario_ImportarUsuariosCancelamentoRegistros_usuarioCadastro] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ImportarUsuariosCancelamentoRegistros] CHECK CONSTRAINT [FK_Funcionario_cd_funcionario_ImportarUsuariosCancelamentoRegistros_usuarioCadastro]
