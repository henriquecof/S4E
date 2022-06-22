/****** Object:  Table [dbo].[ParametroCampanhaEmpresaSituacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ParametroCampanhaEmpresaSituacao](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Situacao] [smallint] NOT NULL,
	[Empresa] [bigint] NOT NULL,
	[UsuarioCadastro] [int] NOT NULL,
	[DataCadastro] [datetime] NOT NULL,
	[UsuarioExclusao] [int] NULL,
	[DataExclusao] [datetime] NULL,
 CONSTRAINT [PK__Parametr__3214EC077292CA98] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao]  WITH CHECK ADD  CONSTRAINT [FK__Parametro__Empre__3AD8815A] FOREIGN KEY([Empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao] CHECK CONSTRAINT [FK__Parametro__Empre__3AD8815A]
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao]  WITH CHECK ADD  CONSTRAINT [FK__Parametro__Empre__747B130A] FOREIGN KEY([Empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao] CHECK CONSTRAINT [FK__Parametro__Empre__747B130A]
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao]  WITH CHECK ADD  CONSTRAINT [FK__Parametro__Situa__3BCCA593] FOREIGN KEY([Situacao])
REFERENCES [dbo].[SITUACAO_HISTORICO] ([CD_SITUACAO_HISTORICO])
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao] CHECK CONSTRAINT [FK__Parametro__Situa__3BCCA593]
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao]  WITH CHECK ADD  CONSTRAINT [FK__Parametro__Situa__756F3743] FOREIGN KEY([Situacao])
REFERENCES [dbo].[SITUACAO_HISTORICO] ([CD_SITUACAO_HISTORICO])
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao] CHECK CONSTRAINT [FK__Parametro__Situa__756F3743]
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao]  WITH CHECK ADD  CONSTRAINT [FK__Parametro__Usuar__3CC0C9CC] FOREIGN KEY([UsuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao] CHECK CONSTRAINT [FK__Parametro__Usuar__3CC0C9CC]
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao]  WITH CHECK ADD  CONSTRAINT [FK__Parametro__Usuar__3DB4EE05] FOREIGN KEY([UsuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao] CHECK CONSTRAINT [FK__Parametro__Usuar__3DB4EE05]
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao]  WITH CHECK ADD  CONSTRAINT [FK__Parametro__Usuar__76635B7C] FOREIGN KEY([UsuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao] CHECK CONSTRAINT [FK__Parametro__Usuar__76635B7C]
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao]  WITH CHECK ADD  CONSTRAINT [FK__Parametro__Usuar__77577FB5] FOREIGN KEY([UsuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ParametroCampanhaEmpresaSituacao] CHECK CONSTRAINT [FK__Parametro__Usuar__77577FB5]
