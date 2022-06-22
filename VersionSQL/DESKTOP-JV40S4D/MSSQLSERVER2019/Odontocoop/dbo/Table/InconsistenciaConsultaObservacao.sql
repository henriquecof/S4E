/****** Object:  Table [dbo].[InconsistenciaConsultaObservacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[InconsistenciaConsultaObservacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencialInconsistencia] [int] NOT NULL,
	[obs] [varchar](1000) NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[dtCadastro] [datetime] NOT NULL,
 CONSTRAINT [PK_InconsistenciaConsultaObservacao] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[InconsistenciaConsultaObservacao]  WITH CHECK ADD  CONSTRAINT [FK_InconsistenciaConsultaObservacao_FUNCIONARIO] FOREIGN KEY([cd_funcionario])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[InconsistenciaConsultaObservacao] CHECK CONSTRAINT [FK_InconsistenciaConsultaObservacao_FUNCIONARIO]
ALTER TABLE [dbo].[InconsistenciaConsultaObservacao]  WITH CHECK ADD  CONSTRAINT [FK_InconsistenciaConsultaObservacao_Inconsistencia_Consulta] FOREIGN KEY([cd_sequencialInconsistencia])
REFERENCES [dbo].[Inconsistencia_Consulta] ([cd_sequencial])
ALTER TABLE [dbo].[InconsistenciaConsultaObservacao] CHECK CONSTRAINT [FK_InconsistenciaConsultaObservacao_Inconsistencia_Consulta]
