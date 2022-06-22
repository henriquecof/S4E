/****** Object:  Table [dbo].[Ans_Beneficiarios]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Ans_Beneficiarios](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NULL,
	[tipo_Movimentacao] [smallint] NOT NULL,
	[dt_inclusao] [datetime] NOT NULL,
	[dt_exclusao] [datetime] NULL,
	[cd_arquivo_envio_inc] [int] NOT NULL,
	[cd_arquivo_envio_exc] [int] NULL,
	[nr_cpf] [varchar](11) NULL,
	[cd_plano_ans] [varchar](10) NULL,
	[nm_beneficiario] [varchar](100) NOT NULL,
	[dt_nascimento] [datetime] NULL,
	[cd_grau_parentesco] [smallint] NULL,
	[cd_beneficiario_titular] [varchar](30) NULL,
	[cd_empresa] [int] NULL,
	[cd_motivo_exclusao_Ans] [smallint] NULL,
	[mensagemErro] [varchar](1000) NULL,
	[cco] [varchar](12) NULL,
	[mudanca_contratual] [bit] NULL,
	[retificacao] [bit] NULL,
	[cd_beneficiario] [varchar](30) NULL,
	[cd_variacao] [int] NULL,
	[oculto] [bit] NULL,
	[dataRetifMudanca] [datetime] NULL,
	[nr_cns] [varchar](15) NULL,
	[executartrigger] [bit] NULL,
 CONSTRAINT [PK_Ans_Envio] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_Ans_Beneficiarios_7] ON [dbo].[Ans_Beneficiarios]
(
	[nr_cpf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_Ans_Beneficiarios_8] ON [dbo].[Ans_Beneficiarios]
(
	[dt_exclusao] ASC,
	[nr_cpf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Ans_Beneficiarios]  WITH NOCHECK ADD  CONSTRAINT [FK_Ans_Beneficiarios_ANS] FOREIGN KEY([cd_arquivo_envio_inc])
REFERENCES [dbo].[ANS] ([cd_sequencial])
ALTER TABLE [dbo].[Ans_Beneficiarios] CHECK CONSTRAINT [FK_Ans_Beneficiarios_ANS]
ALTER TABLE [dbo].[Ans_Beneficiarios]  WITH NOCHECK ADD  CONSTRAINT [FK_Ans_Beneficiarios_ANS1] FOREIGN KEY([cd_arquivo_envio_exc])
REFERENCES [dbo].[ANS] ([cd_sequencial])
ALTER TABLE [dbo].[Ans_Beneficiarios] CHECK CONSTRAINT [FK_Ans_Beneficiarios_ANS1]
ALTER TABLE [dbo].[Ans_Beneficiarios]  WITH NOCHECK ADD  CONSTRAINT [FK_Ans_Beneficiarios_GRAU_PARENTESCO] FOREIGN KEY([cd_grau_parentesco])
REFERENCES [dbo].[GRAU_PARENTESCO] ([cd_grau_parentesco])
ALTER TABLE [dbo].[Ans_Beneficiarios] CHECK CONSTRAINT [FK_Ans_Beneficiarios_GRAU_PARENTESCO]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1-Inclusao, 2-Reativacao' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ans_Beneficiarios', @level2type=N'COLUMN',@level2name=N'tipo_Movimentacao'
