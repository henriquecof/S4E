/****** Object:  Table [dbo].[Importar_Contratos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Importar_Contratos](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_empresa] [bigint] NOT NULL,
	[fl_carenciaAtendimento] [tinyint] NOT NULL,
	[cd_situacao] [smallint] NOT NULL,
	[nm_arquivo] [varchar](100) NOT NULL,
	[qt_registros] [int] NULL,
	[dt_importacao] [datetime] NOT NULL,
	[cd_usuario] [int] NOT NULL,
	[dt_adesao] [date] NOT NULL,
	[cd_vendedor] [int] NOT NULL,
	[obs] [varchar](200) NULL,
	[cd_Adesionista] [int] NULL,
 CONSTRAINT [PK_Importar_Contratos] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Importar_Contratos]  WITH CHECK ADD  CONSTRAINT [FK_IMPARQ_Empresa] FOREIGN KEY([cd_empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ON UPDATE CASCADE
ALTER TABLE [dbo].[Importar_Contratos] CHECK CONSTRAINT [FK_IMPARQ_Empresa]
ALTER TABLE [dbo].[Importar_Contratos]  WITH CHECK ADD  CONSTRAINT [FK_Importar_Contratos_SITUACAO_HISTORICO] FOREIGN KEY([cd_situacao])
REFERENCES [dbo].[SITUACAO_HISTORICO] ([CD_SITUACAO_HISTORICO])
ALTER TABLE [dbo].[Importar_Contratos] CHECK CONSTRAINT [FK_Importar_Contratos_SITUACAO_HISTORICO]
