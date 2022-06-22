/****** Object:  Table [dbo].[empresa_aliquota]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[empresa_aliquota](
	[cd_empresa] [int] NOT NULL,
	[cd_aliquota] [smallint] NOT NULL,
	[id_retencao_aliquota] [tinyint] NOT NULL,
 CONSTRAINT [PK_empresa_aliquota] PRIMARY KEY CLUSTERED 
(
	[cd_empresa] ASC,
	[cd_aliquota] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[empresa_aliquota]  WITH NOCHECK ADD  CONSTRAINT [FK_empresa_aliquota_Aliquota] FOREIGN KEY([cd_aliquota])
REFERENCES [dbo].[Aliquota] ([cd_aliquota])
ALTER TABLE [dbo].[empresa_aliquota] CHECK CONSTRAINT [FK_empresa_aliquota_Aliquota]
ALTER TABLE [dbo].[empresa_aliquota]  WITH NOCHECK ADD  CONSTRAINT [FK_empresa_aliquota_incidencia_aliquota] FOREIGN KEY([id_retencao_aliquota])
REFERENCES [dbo].[retencao_aliquota] ([id_retencao_aliquota])
ALTER TABLE [dbo].[empresa_aliquota] CHECK CONSTRAINT [FK_empresa_aliquota_incidencia_aliquota]
