/****** Object:  Table [dbo].[ItensConsultaCadSus]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ItensConsultaCadSus](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idLote] [int] NOT NULL,
	[idAssociado] [int] NOT NULL,
	[idDependente] [int] NOT NULL,
	[nomeCompleto] [varchar](300) NULL,
	[nomeMae] [varchar](300) NULL,
	[dataNascimento] [datetime] NULL,
	[numeroCNS] [varchar](50) NULL,
	[numeroCPF] [varchar](11) NULL,
	[codigoErro] [varchar](100) NULL,
	[mensagemErro] [varchar](500) NULL,
	[verificado] [bit] NULL,
	[numeroCNSAntigo] [varchar](50) NULL,
 CONSTRAINT [PK_ItensConsultaCadSus] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ItensConsultaCadSus]  WITH CHECK ADD  CONSTRAINT [FK_ItensConsultaCadSus_ASSOCIADOS] FOREIGN KEY([idAssociado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[ItensConsultaCadSus] CHECK CONSTRAINT [FK_ItensConsultaCadSus_ASSOCIADOS]
ALTER TABLE [dbo].[ItensConsultaCadSus]  WITH CHECK ADD  CONSTRAINT [FK_ItensConsultaCadSus_DEPENDENTES] FOREIGN KEY([idDependente])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[ItensConsultaCadSus] CHECK CONSTRAINT [FK_ItensConsultaCadSus_DEPENDENTES]
ALTER TABLE [dbo].[ItensConsultaCadSus]  WITH CHECK ADD  CONSTRAINT [FK_ItensConsultaCadSus_LotesConsultasCadSus] FOREIGN KEY([idLote])
REFERENCES [dbo].[LotesConsultasCadSus] ([idLote])
ALTER TABLE [dbo].[ItensConsultaCadSus] CHECK CONSTRAINT [FK_ItensConsultaCadSus_LotesConsultasCadSus]
