/****** Object:  Table [dbo].[ProtocoloAtendimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ProtocoloAtendimento](
	[patId] [int] IDENTITY(1,1) NOT NULL,
	[patProtocolo] [varchar](50) NOT NULL,
	[patDtCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NULL,
	[cd_empresaCadastro] [int] NULL,
	[tpaId] [tinyint] NOT NULL,
	[patChave] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ProtocoloAtendimento] PRIMARY KEY CLUSTERED 
(
	[patId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IDX_patChave] ON [dbo].[ProtocoloAtendimento]
(
	[patChave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IDX_patProtocolo] ON [dbo].[ProtocoloAtendimento]
(
	[patProtocolo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[ProtocoloAtendimento]  WITH CHECK ADD  CONSTRAINT [FK_ProtocoloAtendimento_TipoProtocoloAtendimento] FOREIGN KEY([tpaId])
REFERENCES [dbo].[TipoProtocoloAtendimento] ([tpaId])
ALTER TABLE [dbo].[ProtocoloAtendimento] CHECK CONSTRAINT [FK_ProtocoloAtendimento_TipoProtocoloAtendimento]
