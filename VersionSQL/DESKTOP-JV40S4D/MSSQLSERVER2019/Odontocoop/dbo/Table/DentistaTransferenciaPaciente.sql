/****** Object:  Table [dbo].[DentistaTransferenciaPaciente]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DentistaTransferenciaPaciente](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[cd_funcionarioAutorizado] [int] NOT NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[dt_exclusao] [datetime] NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[cd_funcionarioExclusao] [int] NULL
) ON [PRIMARY]
