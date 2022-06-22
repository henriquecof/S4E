/****** Object:  Table [dbo].[Campanha]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Campanha](
	[cd_campanha] [smallint] NOT NULL,
	[ds_campanha] [varchar](100) NOT NULL,
	[tp_empresa] [smallint] NULL,
	[qt_dias] [smallint] NULL,
	[hr_inicial] [int] NULL,
	[hr_final] [int] NULL,
	[qt_canais] [smallint] NULL,
	[mensagem_ura] [varchar](200) NULL,
	[nm_script] [varchar](50) NULL,
	[cd_tipo_campanha] [smallint] NOT NULL,
	[cd_origem_campanha] [tinyint] NULL,
	[fl_recarregar_dados] [bit] NULL,
	[cd_prioridade] [smallint] NULL,
	[tsoId] [smallint] NULL,
	[cd_ordem_campanha] [tinyint] NULL,
	[fl_discarDDD] [bit] NULL,
	[resetManual] [bit] NULL,
	[excluirProspect] [bit] NULL,
	[dataVigencia] [datetime] NULL,
	[marcacaoConsulta] [bit] NULL,
	[cobranca] [bit] NULL,
 CONSTRAINT [PK_Campanha] PRIMARY KEY CLUSTERED 
(
	[cd_campanha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Campanha] ADD  CONSTRAINT [DF_Campanha_cd_tipo_campanha]  DEFAULT ((1)) FOR [cd_tipo_campanha]
ALTER TABLE [dbo].[Campanha]  WITH NOCHECK ADD  CONSTRAINT [FK_Campanha_Tipo_Campanha] FOREIGN KEY([cd_tipo_campanha])
REFERENCES [dbo].[Tipo_Campanha] ([cd_tipo_campanha])
ALTER TABLE [dbo].[Campanha] CHECK CONSTRAINT [FK_Campanha_Tipo_Campanha]
ALTER TABLE [dbo].[Campanha]  WITH NOCHECK ADD  CONSTRAINT [FK_Campanha_TIPO_EMPRESA] FOREIGN KEY([tp_empresa])
REFERENCES [dbo].[TIPO_EMPRESA] ([tp_empresa])
ALTER TABLE [dbo].[Campanha] CHECK CONSTRAINT [FK_Campanha_TIPO_EMPRESA]
