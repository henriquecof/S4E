/****** Object:  Table [dbo].[Elegibilidade]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Elegibilidade](
	[eleId] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NULL,
	[eleDtCadastro] [datetime] NULL,
	[cd_funcionarioCadastro] [int] NULL,
	[eleDtExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[eleDtValidade] [datetime] NULL,
	[eleUtilizado] [bit] NULL,
	[eleBiometria] [bit] NULL,
	[cd_filial] [int] NULL,
	[eledescricao] [varchar](50) NULL,
	[elechave] [varchar](50) NULL,
	[cd_funcionarioDentista] [int] NULL,
	[eleUrgencia] [bit] NULL,
	[eleOrtodontia] [bit] NULL,
	[eleTokenSMS] [bit] NULL,
	[eleTipoAtendimento] [tinyint] NULL,
	[idRequisicaoBioFacial] [varchar](50) NULL,
 CONSTRAINT [PK_Elegibilidade] PRIMARY KEY CLUSTERED 
(
	[eleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Elegibilidade] ON [dbo].[Elegibilidade]
(
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_Elegibilidade_1] ON [dbo].[Elegibilidade]
(
	[elechave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Elegibilidade_2] ON [dbo].[Elegibilidade]
(
	[cd_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Elegibilidade_3] ON [dbo].[Elegibilidade]
(
	[cd_funcionarioDentista] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Elegibilidade]  WITH CHECK ADD  CONSTRAINT [FK_Elegibilidade_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[Elegibilidade] CHECK CONSTRAINT [FK_Elegibilidade_DEPENDENTES]
ALTER TABLE [dbo].[Elegibilidade]  WITH CHECK ADD  CONSTRAINT [FK_Elegibilidade_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[Elegibilidade] CHECK CONSTRAINT [FK_Elegibilidade_FILIAL]
