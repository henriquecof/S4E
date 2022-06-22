/****** Object:  Table [dbo].[BiometriaFacialToken]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[BiometriaFacialToken](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[token] [uniqueidentifier] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_sequencial_dep] [int] NULL,
	[identificadorExterno] [varchar](100) NULL,
	[elegibilidade] [bit] NULL,
	[observacoes] [varchar](100) NULL,
	[idTokenCredencial] [int] NULL,
 CONSTRAINT [PK_BiometriaFacialToken] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_BiometriaFacialToken] ON [dbo].[BiometriaFacialToken]
(
	[token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[BiometriaFacialToken]  WITH CHECK ADD  CONSTRAINT [FK_BiometriaFacialToken_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[BiometriaFacialToken] CHECK CONSTRAINT [FK_BiometriaFacialToken_DEPENDENTES]
ALTER TABLE [dbo].[BiometriaFacialToken]  WITH CHECK ADD  CONSTRAINT [FK_BiometriaFacialToken_TokenCredencial] FOREIGN KEY([idTokenCredencial])
REFERENCES [dbo].[TokenCredencial] ([id])
ALTER TABLE [dbo].[BiometriaFacialToken] CHECK CONSTRAINT [FK_BiometriaFacialToken_TokenCredencial]
