/****** Object:  Table [dbo].[TB_EnvioEmail]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_EnvioEmail](
	[eemId] [int] IDENTITY(1,1) NOT NULL,
	[eemDestinatarioEmail] [varchar](255) NOT NULL,
	[eemAssunto] [varchar](255) NOT NULL,
	[eemMensagem] [varchar](max) NOT NULL,
	[cd_associado] [int] NULL,
	[cd_sequencial_dep] [smallint] NULL,
	[eemHTML] [smallint] NULL,
	[eemDtCadastro] [datetime] NOT NULL,
	[eemDtEnvio] [datetime] NULL,
	[eemDtVisualizacao] [datetime] NULL,
	[eemDtExclusao] [datetime] NULL,
 CONSTRAINT [PK_TB_EnvioEmail] PRIMARY KEY CLUSTERED 
(
	[eemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_TB_EnvioEmail_2] ON [dbo].[TB_EnvioEmail]
(
	[eemDtVisualizacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TB_EnvioEmail] ADD  CONSTRAINT [DF_TB_EnvioEmail_eemHTML]  DEFAULT ((1)) FOR [eemHTML]
