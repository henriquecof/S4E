/****** Object:  Table [dbo].[IntegracaoProcedimentos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[IntegracaoProcedimentos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[chave] [varchar](100) NOT NULL,
	[idIntegrador] [uniqueidentifier] NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[cd_filial] [int] NOT NULL,
	[guiaPrestador] [varchar](50) NOT NULL,
	[atendimentoUrgencia] [varchar](1) NOT NULL,
	[obsGuiaPrestador] [varchar](500) NULL,
	[codigo] [int] NOT NULL,
	[dente] [tinyint] NULL,
	[faces] [varchar](10) NULL,
	[regiao] [varchar](10) NULL,
	[carteiraBeneficiario] [varchar](20) NULL,
	[cpfBeneficiario] [varchar](11) NULL,
	[dataCadastro] [datetime] NOT NULL,
	[ip] [varchar](50) NULL,
	[dataExclusao] [datetime] NULL,
 CONSTRAINT [PK_IntegracaoProcedimentos] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[IntegracaoProcedimentos]  WITH CHECK ADD  CONSTRAINT [FK_IntegracaoProcedimentos_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[IntegracaoProcedimentos] CHECK CONSTRAINT [FK_IntegracaoProcedimentos_FILIAL]
