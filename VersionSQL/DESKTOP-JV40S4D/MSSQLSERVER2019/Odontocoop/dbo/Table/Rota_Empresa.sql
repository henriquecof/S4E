/****** Object:  Table [dbo].[Rota_Empresa]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Rota_Empresa](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_rota] [int] NOT NULL,
	[cd_empresa] [bigint] NOT NULL,
	[dt_CadastroRota] [datetime] NOT NULL,
	[observacao] [varchar](500) NULL,
	[ordem] [int] NULL,
 CONSTRAINT [PK_Rota_Empresa] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Rota_Empresa]  WITH CHECK ADD  CONSTRAINT [FK_Rota_Empresa_EMPRESA] FOREIGN KEY([cd_empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ON UPDATE CASCADE
ALTER TABLE [dbo].[Rota_Empresa] CHECK CONSTRAINT [FK_Rota_Empresa_EMPRESA]
ALTER TABLE [dbo].[Rota_Empresa]  WITH CHECK ADD  CONSTRAINT [FK_Rota_Empresa_Rota] FOREIGN KEY([cd_sequencial_rota])
REFERENCES [dbo].[Rota] ([cd_sequencial_rota])
ALTER TABLE [dbo].[Rota_Empresa] CHECK CONSTRAINT [FK_Rota_Empresa_Rota]
