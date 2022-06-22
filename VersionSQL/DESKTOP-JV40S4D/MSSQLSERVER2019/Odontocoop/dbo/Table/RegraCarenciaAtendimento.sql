/****** Object:  Table [dbo].[RegraCarenciaAtendimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RegraCarenciaAtendimento](
	[rcaID] [int] IDENTITY(1,1) NOT NULL,
	[rcaDescricao] [varchar](50) NOT NULL,
	[qt_dias_urgencia] [smallint] NOT NULL,
	[qt_dias_clinico] [smallint] NOT NULL,
	[tcaId] [smallint] NOT NULL,
	[rcaAtivo] [bit] NOT NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[usuario_cadastro] [int] NOT NULL,
	[dt_exclusao] [datetime] NULL,
	[usuario_exclusao] [int] NULL,
	[rcaPercentualCobertura] [int] NULL,
	[rcaUrgenciaRefAdesao] [bit] NULL,
	[rcaUrgenciaLiberada] [bit] NULL,
 CONSTRAINT [PK_RegraCarenciaAtendimento] PRIMARY KEY CLUSTERED 
(
	[rcaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RegraCarenciaAtendimento]  WITH NOCHECK ADD  CONSTRAINT [FK_RegraCarenciaAtendimento_TipoCarenciaAtendimento] FOREIGN KEY([rcaID])
REFERENCES [dbo].[RegraCarenciaAtendimento] ([rcaID])
ALTER TABLE [dbo].[RegraCarenciaAtendimento] CHECK CONSTRAINT [FK_RegraCarenciaAtendimento_TipoCarenciaAtendimento]
