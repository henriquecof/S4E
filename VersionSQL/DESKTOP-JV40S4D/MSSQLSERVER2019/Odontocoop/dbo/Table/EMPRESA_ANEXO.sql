/****** Object:  Table [dbo].[EMPRESA_ANEXO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPRESA_ANEXO](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_empresa] [bigint] NOT NULL,
	[usuario_exclusao] [int] NULL,
	[data_exclusao] [datetime] NULL,
	[nome_arquivo] [varchar](100) NOT NULL,
	[extensao_arquivo] [varchar](4) NOT NULL,
	[id_dominio_valor] [int] NULL,
 CONSTRAINT [PK_EMPRESA_ANEXO] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EMPRESA_ANEXO]  WITH CHECK ADD  CONSTRAINT [FK_EMPRESA_ANEXO_EMPRESA] FOREIGN KEY([cd_empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ON UPDATE CASCADE
ALTER TABLE [dbo].[EMPRESA_ANEXO] CHECK CONSTRAINT [FK_EMPRESA_ANEXO_EMPRESA]
