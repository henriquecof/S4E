/****** Object:  Table [dbo].[Falta_Substituicao_Dentista]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Falta_Substituicao_Dentista](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[dt_compromisso] [datetime] NOT NULL,
	[cd_filial] [int] NOT NULL,
	[cd_funcionario] [int] NULL,
	[qt_horas] [datetime] NULL,
	[cd_funcionario_substituicao] [int] NULL,
	[vl_hora] [money] NULL,
	[HI] [datetime] NOT NULL,
	[HF] [datetime] NOT NULL,
	[motivo] [varchar](50) NULL,
	[dt_exclusao] [datetime] NULL,
	[qt_horarios_marcados] [smallint] NULL,
	[cd_funcionario_inclusao] [int] NULL,
	[cd_funcionario_exclusao] [int] NULL,
	[dt_cadastro] [datetime] NULL,
	[cd_filial_substituicao] [int] NULL,
	[motivoReservaId] [int] NULL,
 CONSTRAINT [PK_Falta_Substituicao_Dentista] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Falta_Substituicao_Dentista]  WITH NOCHECK ADD  CONSTRAINT [FK_Falta_Substituicao_Dentista_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[Falta_Substituicao_Dentista] CHECK CONSTRAINT [FK_Falta_Substituicao_Dentista_FILIAL]
