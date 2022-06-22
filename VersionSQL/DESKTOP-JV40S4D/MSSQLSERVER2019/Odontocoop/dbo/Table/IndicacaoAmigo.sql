/****** Object:  Table [dbo].[IndicacaoAmigo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IndicacaoAmigo](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_associado] [int] NOT NULL,
	[nm_indicado] [varchar](100) NOT NULL,
	[telefone_indicado] [varchar](11) NULL,
	[email_indicado] [varchar](50) NULL,
	[dt_cadastro] [datetime] NOT NULL,
 CONSTRAINT [PK_IndicacaoAmigo] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[IndicacaoAmigo]  WITH CHECK ADD  CONSTRAINT [FK_IndicacaoAmigo_ASSOCIADOS] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[IndicacaoAmigo] CHECK CONSTRAINT [FK_IndicacaoAmigo_ASSOCIADOS]
