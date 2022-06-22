/****** Object:  Table [dbo].[Aliquota]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Aliquota](
	[cd_aliquota] [smallint] IDENTITY(1,1) NOT NULL,
	[cd_grupo_aliquota] [tinyint] NOT NULL,
	[ds_aliquota] [varchar](50) NOT NULL,
	[perc_aliquota] [float] NOT NULL,
	[fl_ativo] [smallint] NOT NULL,
	[id_referencia] [tinyint] NOT NULL,
	[vl_referencia] [money] NOT NULL,
	[vl_maximo_deducao] [money] NULL,
	[data_alteracao] [datetime] NULL,
	[cd_funcionario] [int] NULL,
 CONSTRAINT [PK_Aliquota] PRIMARY KEY CLUSTERED 
(
	[cd_aliquota] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IN_Aliquota] ON [dbo].[Aliquota]
(
	[cd_grupo_aliquota] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Aliquota]  WITH NOCHECK ADD  CONSTRAINT [FK_Aliquota_Aliquota] FOREIGN KEY([id_referencia])
REFERENCES [dbo].[referencia_aliquota] ([id_referencia])
ALTER TABLE [dbo].[Aliquota] CHECK CONSTRAINT [FK_Aliquota_Aliquota]
ALTER TABLE [dbo].[Aliquota]  WITH NOCHECK ADD  CONSTRAINT [FK_Aliquota_GrupoAliquota] FOREIGN KEY([cd_grupo_aliquota])
REFERENCES [dbo].[GrupoAliquota] ([cd_grupo_aliquota])
ALTER TABLE [dbo].[Aliquota] CHECK CONSTRAINT [FK_Aliquota_GrupoAliquota]
ALTER TABLE [dbo].[Aliquota]  WITH CHECK ADD  CONSTRAINT [fk_cd_funcionario] FOREIGN KEY([cd_funcionario])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Aliquota] CHECK CONSTRAINT [fk_cd_funcionario]
