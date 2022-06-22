/****** Object:  Table [dbo].[TB_Contato]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Contato](
	[tusSequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_origeminformacao] [int] NOT NULL,
	[cd_sequencial] [int] NOT NULL,
	[tteSequencial] [smallint] NOT NULL,
	[tusTelefone] [varchar](50) NOT NULL,
	[tusDtCadastro] [datetime] NOT NULL,
	[tusDtAtualizacao] [datetime] NOT NULL,
	[tusQuantidade] [int] NOT NULL,
	[fl_ativo] [bit] NOT NULL,
	[contato] [varchar](50) NULL,
	[tusCapturado] [bit] NULL,
	[iacId] [smallint] NULL,
	[cd_funcionarioAtualizacao] [int] NULL,
	[fl_prioritario] [bit] NULL,
	[divulgar_rede] [bit] NULL,
	[executarTrigger] [bit] NULL,
	[fl_envioCrm] [tinyint] NULL,
	[fl_envioFaturamento] [tinyint] NULL,
	[UsuarioAlteracao] [int] NULL,
	[tipoUsuarioAlteracao] [int] NULL,
 CONSTRAINT [PK_TB_TelefoneUsuario] PRIMARY KEY CLUSTERED 
(
	[tusSequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_TB_Contato] ON [dbo].[TB_Contato]
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_Contato_1] ON [dbo].[TB_Contato]
(
	[tusDtAtualizacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_TB_Contato_2] ON [dbo].[TB_Contato]
(
	[tusTelefone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_TB_TelefoneUsuario_1] ON [dbo].[TB_Contato]
(
	[cd_sequencial] ASC,
	[tusTelefone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TB_Contato]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Contato_InformacaoAdicionalContato] FOREIGN KEY([iacId])
REFERENCES [dbo].[InformacaoAdicionalContato] ([iacId])
ALTER TABLE [dbo].[TB_Contato] CHECK CONSTRAINT [FK_TB_Contato_InformacaoAdicionalContato]
ALTER TABLE [dbo].[TB_Contato]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_TelefoneUsuario_TB_OrigemInformacao] FOREIGN KEY([cd_origeminformacao])
REFERENCES [dbo].[TB_OrigemInformacao] ([cd_origeminformacao])
ALTER TABLE [dbo].[TB_Contato] CHECK CONSTRAINT [FK_TB_TelefoneUsuario_TB_OrigemInformacao]
ALTER TABLE [dbo].[TB_Contato]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_TelefoneUsuario_TB_TipoTelefone] FOREIGN KEY([tteSequencial])
REFERENCES [dbo].[TB_TipoContato] ([tteSequencial])
ALTER TABLE [dbo].[TB_Contato] CHECK CONSTRAINT [FK_TB_TelefoneUsuario_TB_TipoTelefone]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Origem Informação|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Contato', @level2type=N'COLUMN',@level2name=N'cd_origeminformacao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Contato', @level2type=N'COLUMN',@level2name=N'tteSequencial'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contato|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TB_Contato', @level2type=N'COLUMN',@level2name=N'tusTelefone'
