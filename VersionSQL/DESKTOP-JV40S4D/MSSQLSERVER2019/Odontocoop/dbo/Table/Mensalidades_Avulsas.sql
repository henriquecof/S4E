/****** Object:  Table [dbo].[Mensalidades_Avulsas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Mensalidades_Avulsas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NULL,
	[cd_tipo_parcela] [smallint] NOT NULL,
	[dt_vencimento] [date] NULL,
	[dt_inclusao] [datetime] NOT NULL,
	[valor] [money] NOT NULL,
	[dt_vencimento_final] [date] NULL,
	[dt_exclusao] [date] NULL,
	[cd_empresa] [int] NULL,
	[usuarioCadastro] [int] NULL,
	[aceita_porcentagem] [bit] NULL,
	[ds_avulsa] [varchar](100) NULL,
 CONSTRAINT [PK_Mensalidades_Avulsas] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Mensalidades_Avulsas]  WITH CHECK ADD  CONSTRAINT [FK_Mensalidades_Avulsas_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[Mensalidades_Avulsas] CHECK CONSTRAINT [FK_Mensalidades_Avulsas_DEPENDENTES]
ALTER TABLE [dbo].[Mensalidades_Avulsas]  WITH CHECK ADD  CONSTRAINT [FK_Mensalidades_Avulsas_Tipo_parcela] FOREIGN KEY([cd_tipo_parcela])
REFERENCES [dbo].[Tipo_parcela] ([cd_tipo_parcela])
ALTER TABLE [dbo].[Mensalidades_Avulsas] CHECK CONSTRAINT [FK_Mensalidades_Avulsas_Tipo_parcela]
