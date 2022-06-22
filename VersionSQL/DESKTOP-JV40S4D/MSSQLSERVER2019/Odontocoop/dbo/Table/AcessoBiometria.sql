/****** Object:  Table [dbo].[AcessoBiometria]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AcessoBiometria](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_funcionario] [int] NULL,
	[cd_sequencial_dep] [int] NULL,
	[cd_filial] [int] NULL,
	[data_cadastro] [datetime] NOT NULL,
	[data_validade] [datetime] NOT NULL,
	[ip] [varchar](50) NOT NULL,
 CONSTRAINT [PK_AcessoBiometria] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_AcessoBiometria_Filial] ON [dbo].[AcessoBiometria]
(
	[cd_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_AcessoBiometria_Funcionario] ON [dbo].[AcessoBiometria]
(
	[cd_funcionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_AcessoBiometria_FuncionarioValidade] ON [dbo].[AcessoBiometria]
(
	[cd_funcionario] ASC,
	[data_validade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[AcessoBiometria]  WITH CHECK ADD  CONSTRAINT [FK_AcessoBiometria_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[AcessoBiometria] CHECK CONSTRAINT [FK_AcessoBiometria_DEPENDENTES]
ALTER TABLE [dbo].[AcessoBiometria]  WITH CHECK ADD  CONSTRAINT [FK_AcessoBiometria_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[AcessoBiometria] CHECK CONSTRAINT [FK_AcessoBiometria_FILIAL]
