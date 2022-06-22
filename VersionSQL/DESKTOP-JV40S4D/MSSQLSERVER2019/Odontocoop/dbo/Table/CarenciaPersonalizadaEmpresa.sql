/****** Object:  Table [dbo].[CarenciaPersonalizadaEmpresa]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CarenciaPersonalizadaEmpresa](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DataInicial] [date] NOT NULL,
	[DataFinal] [date] NULL,
	[cd_empresa] [bigint] NOT NULL,
	[cd_plano] [int] NULL,
	[cd_especialidade] [int] NULL,
	[cd_servico] [int] NULL,
	[DiasCarencia] [int] NOT NULL,
	[depid] [int] NULL,
	[DataExclusao] [date] NULL,
	[UsuarioExclusao] [int] NULL,
	[idGrupoCarencia] [int] NULL,
 CONSTRAINT [PK__Carencia__3214EC07264778C8] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CarenciaPersonalizadaEmpresa]  WITH CHECK ADD  CONSTRAINT [FK_CarenciaPersonalizadaEmpresa_cd_empresa_Empresa_cd_empresa] FOREIGN KEY([cd_empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[CarenciaPersonalizadaEmpresa] CHECK CONSTRAINT [FK_CarenciaPersonalizadaEmpresa_cd_empresa_Empresa_cd_empresa]
ALTER TABLE [dbo].[CarenciaPersonalizadaEmpresa]  WITH CHECK ADD  CONSTRAINT [FK_CarenciaPersonalizadaEmpresa_cd_especialidade_Especialidade_cd_especialidade] FOREIGN KEY([cd_especialidade])
REFERENCES [dbo].[ESPECIALIDADE] ([cd_especialidade])
ALTER TABLE [dbo].[CarenciaPersonalizadaEmpresa] CHECK CONSTRAINT [FK_CarenciaPersonalizadaEmpresa_cd_especialidade_Especialidade_cd_especialidade]
ALTER TABLE [dbo].[CarenciaPersonalizadaEmpresa]  WITH CHECK ADD  CONSTRAINT [FK_CarenciaPersonalizadaEmpresa_cd_plano_Planos_cd_plano] FOREIGN KEY([cd_plano])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[CarenciaPersonalizadaEmpresa] CHECK CONSTRAINT [FK_CarenciaPersonalizadaEmpresa_cd_plano_Planos_cd_plano]
ALTER TABLE [dbo].[CarenciaPersonalizadaEmpresa]  WITH CHECK ADD  CONSTRAINT [FK_CarenciaPersonalizadaEmpresa_cd_servico_Servico_cd_servico] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[CarenciaPersonalizadaEmpresa] CHECK CONSTRAINT [FK_CarenciaPersonalizadaEmpresa_cd_servico_Servico_cd_servico]
ALTER TABLE [dbo].[CarenciaPersonalizadaEmpresa]  WITH CHECK ADD  CONSTRAINT [FK_Funcionario_cd_funcionario_CarenciaPersonalizadaEmpresa_UsuarioExclusao] FOREIGN KEY([UsuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[CarenciaPersonalizadaEmpresa] CHECK CONSTRAINT [FK_Funcionario_cd_funcionario_CarenciaPersonalizadaEmpresa_UsuarioExclusao]
