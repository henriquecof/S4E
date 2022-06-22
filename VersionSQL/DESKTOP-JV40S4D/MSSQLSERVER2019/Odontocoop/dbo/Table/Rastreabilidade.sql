/****** Object:  Table [dbo].[Rastreabilidade]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Rastreabilidade](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [int] NOT NULL,
	[descricao] [varchar](50) NOT NULL,
	[quantidade] [float] NOT NULL,
	[lote] [varchar](50) NULL,
	[validade] [datetime] NULL,
	[codigoBarras] [varchar](50) NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_sequencialConsulta] [int] NULL,
	[dataInclusao] [datetime] NOT NULL,
	[usuarioInclusao] [int] NOT NULL,
	[tipoUsuarioInclusao] [tinyint] NOT NULL,
	[dataExclusao] [datetime] NULL,
	[usuarioExclusao] [int] NULL,
	[tipoUsuarioExclusao] [tinyint] NULL,
 CONSTRAINT [PK_Rastreabilidade] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Rastreabilidade] ON [dbo].[Rastreabilidade]
(
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Rastreabilidade_1] ON [dbo].[Rastreabilidade]
(
	[cd_sequencialConsulta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Rastreabilidade]  WITH CHECK ADD  CONSTRAINT [FK_Rastreabilidade_Consultas] FOREIGN KEY([cd_sequencialConsulta])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[Rastreabilidade] CHECK CONSTRAINT [FK_Rastreabilidade_Consultas]
ALTER TABLE [dbo].[Rastreabilidade]  WITH CHECK ADD  CONSTRAINT [FK_Rastreabilidade_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[Rastreabilidade] CHECK CONSTRAINT [FK_Rastreabilidade_DEPENDENTES]
