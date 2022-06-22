/****** Object:  Table [dbo].[lote_sispag_retorno]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[lote_sispag_retorno](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[nm_arquivo] [varchar](100) NOT NULL,
	[qt_registros] [int] NOT NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[codigo_banco] [smallint] NULL,
	[cd_funcionarioCadastro] [int] NULL,
	[cd_sequencial_malote] [int] NULL,
	[obs] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[lote_sispag_retorno]  WITH CHECK ADD  CONSTRAINT [FK_FUNCIONARIO_2_cd_funcionario_cd_funcionarioCadastro] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[lote_sispag_retorno] CHECK CONSTRAINT [FK_FUNCIONARIO_2_cd_funcionario_cd_funcionarioCadastro]
ALTER TABLE [dbo].[lote_sispag_retorno]  WITH CHECK ADD  CONSTRAINT [FK_TB_Malote_2_cd_sequencial_malote] FOREIGN KEY([cd_sequencial_malote])
REFERENCES [dbo].[TB_Malote] ([cd_sequencial_malote])
ALTER TABLE [dbo].[lote_sispag_retorno] CHECK CONSTRAINT [FK_TB_Malote_2_cd_sequencial_malote]
