/****** Object:  Table [dbo].[TB_PontoFeriado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_PontoFeriado](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[dt_feriado] [datetime] NOT NULL,
	[cd_centro_custo] [smallint] NULL,
	[motivo] [varchar](100) NOT NULL,
	[cd_periodo] [tinyint] NOT NULL,
	[cd_funcionario] [int] NULL,
	[cd_funcionario_inclusao] [int] NOT NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[cd_funcionario_exclusao] [int] NULL,
	[dt_exclusao] [datetime] NULL,
	[cd_filial] [int] NULL,
 CONSTRAINT [PK_TB_PontoFeriado] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_PontoFeriado]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_PontoFeriado_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[TB_PontoFeriado] CHECK CONSTRAINT [FK_TB_PontoFeriado_Centro_Custo]
ALTER TABLE [dbo].[TB_PontoFeriado]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_PontoFeriado_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[TB_PontoFeriado] CHECK CONSTRAINT [FK_TB_PontoFeriado_FILIAL]
