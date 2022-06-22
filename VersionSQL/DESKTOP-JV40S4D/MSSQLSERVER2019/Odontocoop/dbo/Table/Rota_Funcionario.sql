/****** Object:  Table [dbo].[Rota_Funcionario]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Rota_Funcionario](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[cd_sequencial_rota] [int] NOT NULL,
	[dt_cadastroRota] [datetime] NOT NULL,
	[cd_empresa] [bigint] NULL,
	[ordem] [int] NULL,
	[observacao] [varchar](500) NULL,
 CONSTRAINT [PK_Rota_Funcionario] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Rota_Funcionario]  WITH CHECK ADD  CONSTRAINT [FK_Rota_Funcionario_EMPRESA] FOREIGN KEY([cd_empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ON UPDATE CASCADE
ALTER TABLE [dbo].[Rota_Funcionario] CHECK CONSTRAINT [FK_Rota_Funcionario_EMPRESA]
ALTER TABLE [dbo].[Rota_Funcionario]  WITH CHECK ADD  CONSTRAINT [FK_Rota_Funcionario_Rota] FOREIGN KEY([cd_sequencial_rota])
REFERENCES [dbo].[Rota] ([cd_sequencial_rota])
ALTER TABLE [dbo].[Rota_Funcionario] CHECK CONSTRAINT [FK_Rota_Funcionario_Rota]
