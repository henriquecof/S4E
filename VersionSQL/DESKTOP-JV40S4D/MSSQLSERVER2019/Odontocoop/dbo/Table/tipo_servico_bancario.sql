/****** Object:  Table [dbo].[tipo_servico_bancario]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tipo_servico_bancario](
	[cd_tipo_servico_bancario] [smallint] NOT NULL,
	[ds_tipo_servico_bancario] [varchar](50) NOT NULL,
	[fl_recorrente] [bit] NOT NULL,
	[qt_diasminimo] [smallint] NOT NULL,
	[vl_taxa] [money] NULL,
	[qt_parcelas] [int] NULL,
	[qt_maxima_repeticao_arquivo] [smallint] NOT NULL,
	[qt_diasmaximo] [smallint] NOT NULL,
	[qt_parcelas_complementar] [int] NULL,
	[fl_carne] [bit] NULL,
	[qt_diasmaximo_1carne] [smallint] NULL,
	[fl_referencia] [smallint] NULL,
	[cd_padrao_servico] [smallint] NULL,
	[faixaOcorrencia] [int] NULL,
 CONSTRAINT [PK_tipo_servico_bancario] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_servico_bancario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[tipo_servico_bancario] ADD  CONSTRAINT [DF_tipo_servico_bancario_qt_maxima_repeticao_arquivo]  DEFAULT ((1)) FOR [qt_maxima_repeticao_arquivo]
ALTER TABLE [dbo].[tipo_servico_bancario]  WITH CHECK ADD  CONSTRAINT [FK_tipo_servico_bancario_Padrao_Servico] FOREIGN KEY([cd_padrao_servico])
REFERENCES [dbo].[Padrao_Servico] ([cd_padrao_servico])
ALTER TABLE [dbo].[tipo_servico_bancario] CHECK CONSTRAINT [FK_tipo_servico_bancario_Padrao_Servico]
