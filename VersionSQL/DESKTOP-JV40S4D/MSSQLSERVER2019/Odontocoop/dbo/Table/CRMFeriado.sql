/****** Object:  Table [dbo].[CRMFeriado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMFeriado](
	[ferId] [int] IDENTITY(1,1) NOT NULL,
	[ferDescricao] [varchar](50) NOT NULL,
	[ferData] [datetime] NOT NULL,
	[ferHorarioInicial] [int] NOT NULL,
	[ferHorarioFinal] [int] NOT NULL,
	[CD_MUNICIPIO] [int] NULL,
	[permiteLogin] [bit] NULL,
 CONSTRAINT [PK_CRMFeriado] PRIMARY KEY CLUSTERED 
(
	[ferId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_CRMFeriado] ON [dbo].[CRMFeriado]
(
	[ferData] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CRMFeriado_1] ON [dbo].[CRMFeriado]
(
	[ferHorarioInicial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CRMFeriado_2] ON [dbo].[CRMFeriado]
(
	[ferHorarioFinal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CRMFeriado]  WITH CHECK ADD  CONSTRAINT [FK_CRMFeriado_MUNICIPIO] FOREIGN KEY([CD_MUNICIPIO])
REFERENCES [dbo].[MUNICIPIO] ([CD_MUNICIPIO])
ALTER TABLE [dbo].[CRMFeriado] CHECK CONSTRAINT [FK_CRMFeriado_MUNICIPIO]
