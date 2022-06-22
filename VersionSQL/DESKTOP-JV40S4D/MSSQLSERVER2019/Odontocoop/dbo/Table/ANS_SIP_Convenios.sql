/****** Object:  Table [dbo].[ANS_SIP_Convenios]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ANS_SIP_Convenios](
	[ano_trimestre] [int] NOT NULL,
	[tipo_empresa] [smallint] NOT NULL,
	[cd_categoria_ans] [smallint] NOT NULL,
	[qt_eventos] [int] NOT NULL,
	[qt_beneficiarios] [int] NULL,
	[vl_despesa] [money] NULL,
	[uf] [smallint] NOT NULL,
	[cd_arquivo] [int] NULL,
	[ano_trimestre_execucao] [int] NOT NULL,
	[semMovimento] [bit] NULL,
	[IdConvenio] [int] NOT NULL,
 CONSTRAINT [PK_ANS_SIP_Convenios] PRIMARY KEY CLUSTERED 
(
	[ano_trimestre] ASC,
	[tipo_empresa] ASC,
	[cd_categoria_ans] ASC,
	[uf] ASC,
	[ano_trimestre_execucao] ASC,
	[IdConvenio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ANS_SIP_Convenios]  WITH NOCHECK ADD  CONSTRAINT [FK_ANS_SIP_Convenios_Categoria_Ans] FOREIGN KEY([cd_categoria_ans])
REFERENCES [dbo].[Categoria_Ans] ([cd_categoria_ans])
ALTER TABLE [dbo].[ANS_SIP_Convenios] CHECK CONSTRAINT [FK_ANS_SIP_Convenios_Categoria_Ans]
ALTER TABLE [dbo].[ANS_SIP_Convenios]  WITH NOCHECK ADD  CONSTRAINT [FK_ANS_SIP_Convenios_CLASSIFICACAO_ANS] FOREIGN KEY([tipo_empresa])
REFERENCES [dbo].[TIPO_EMPRESA] ([tp_empresa])
ALTER TABLE [dbo].[ANS_SIP_Convenios] CHECK CONSTRAINT [FK_ANS_SIP_Convenios_CLASSIFICACAO_ANS]
ALTER TABLE [dbo].[ANS_SIP_Convenios]  WITH CHECK ADD  CONSTRAINT [FK_Convenio_Id_ANS_SIP_Convenios_IdConvenio] FOREIGN KEY([IdConvenio])
REFERENCES [dbo].[Convenio] ([Id])
ALTER TABLE [dbo].[ANS_SIP_Convenios] CHECK CONSTRAINT [FK_Convenio_Id_ANS_SIP_Convenios_IdConvenio]
