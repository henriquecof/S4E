/****** Object:  Table [dbo].[PesquisaRedeAtendimentoFilial]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PesquisaRedeAtendimentoFilial](
	[idPesquisa] [int] NOT NULL,
	[cd_filial] [int] NOT NULL,
 CONSTRAINT [PesquisaRedeAtendimentoFilial_1] PRIMARY KEY CLUSTERED 
(
	[idPesquisa] ASC,
	[cd_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PesquisaRedeAtendimentoFilial]  WITH CHECK ADD  CONSTRAINT [PesquisaRedeAtendimentoFilial_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[PesquisaRedeAtendimentoFilial] CHECK CONSTRAINT [PesquisaRedeAtendimentoFilial_FILIAL]
ALTER TABLE [dbo].[PesquisaRedeAtendimentoFilial]  WITH CHECK ADD  CONSTRAINT [PesquisaRedeAtendimentoFilial_PesquisaRedeAtendimento] FOREIGN KEY([idPesquisa])
REFERENCES [dbo].[PesquisaRedeAtendimento] ([id])
ALTER TABLE [dbo].[PesquisaRedeAtendimentoFilial] CHECK CONSTRAINT [PesquisaRedeAtendimentoFilial_PesquisaRedeAtendimento]
