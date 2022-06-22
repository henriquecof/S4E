/****** Object:  Table [dbo].[Inconsistencia_Consulta]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Inconsistencia_Consulta](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_consulta] [int] NULL,
	[ds_erro] [varchar](2000) NULL,
	[dt_analise] [datetime] NULL,
	[cd_funcionario] [int] NULL,
	[ds_motivo] [varchar](2000) NULL,
	[status] [smallint] NULL,
	[cd_sequencial_consultaTemp] [int] NULL,
	[cd_regra] [int] NULL,
	[dt_cadastro_solicitacao] [datetime] NULL,
 CONSTRAINT [PK_Inconsistencia_Consulta] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Inconsistencia_Consulta] ADD  CONSTRAINT [DF_Inconsistencia_Consulta_status]  DEFAULT ((0)) FOR [status]
ALTER TABLE [dbo].[Inconsistencia_Consulta] ADD  CONSTRAINT [DF_Inconsistencia_Consulta_dt_cadastro_solicitacao]  DEFAULT (getdate()) FOR [dt_cadastro_solicitacao]
ALTER TABLE [dbo].[Inconsistencia_Consulta]  WITH NOCHECK ADD  CONSTRAINT [FK_Inconsistencia_Consulta_Consultas] FOREIGN KEY([cd_sequencial_consulta])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[Inconsistencia_Consulta] CHECK CONSTRAINT [FK_Inconsistencia_Consulta_Consultas]
