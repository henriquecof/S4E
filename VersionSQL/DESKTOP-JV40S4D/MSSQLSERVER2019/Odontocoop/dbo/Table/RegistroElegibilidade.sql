/****** Object:  Table [dbo].[RegistroElegibilidade]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RegistroElegibilidade](
	[relId] [int] IDENTITY(1,1) NOT NULL,
	[relDataRegistroTransacao] [datetime] NOT NULL,
	[relIdentificacaoPrestador] [varchar](14) NOT NULL,
	[relRespostaSolicitacao] [bit] NOT NULL,
	[relCodigoGlosa] [smallint] NULL,
	[relDescricaoGlosa] [varchar](500) NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_filial] [int] NULL,
	[cd_funcionarioDentista] [int] NULL,
	[cd_funcionarioSolicitacao] [int] NULL,
	[relIP] [varchar](20) NOT NULL,
	[relChave] [varchar](50) NOT NULL,
 CONSTRAINT [PK_RegistroElegibilidade] PRIMARY KEY CLUSTERED 
(
	[relId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RegistroElegibilidade]  WITH CHECK ADD  CONSTRAINT [FK_RegistroElegibilidade_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[RegistroElegibilidade] CHECK CONSTRAINT [FK_RegistroElegibilidade_DEPENDENTES]
ALTER TABLE [dbo].[RegistroElegibilidade]  WITH CHECK ADD  CONSTRAINT [FK_RegistroElegibilidade_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[RegistroElegibilidade] CHECK CONSTRAINT [FK_RegistroElegibilidade_FILIAL]
