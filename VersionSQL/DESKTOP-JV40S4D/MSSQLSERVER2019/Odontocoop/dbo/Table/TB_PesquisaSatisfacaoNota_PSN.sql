/****** Object:  Table [dbo].[TB_PesquisaSatisfacaoNota_PSN]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_PesquisaSatisfacaoNota_PSN](
	[SequencialPesquisaSatisfacaoNota_PSN] [int] IDENTITY(1,1) NOT NULL,
	[SequencialPesquisaSatisfacaoUsuario_PSU] [int] NOT NULL,
	[cd_sequencial_resposta] [int] NOT NULL,
	[Nota_PSN] [smallint] NOT NULL,
	[MotivoNota_PSN] [varchar](150) NULL,
 CONSTRAINT [PK_TB_PesquisaSatisfacaoNota_PSN] PRIMARY KEY CLUSTERED 
(
	[SequencialPesquisaSatisfacaoNota_PSN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_PesquisaSatisfacaoNota_PSN]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_PesquisaSatisfacaoNota_PSN_TB_PesquisaSatisfacaoUsuario_PSU] FOREIGN KEY([SequencialPesquisaSatisfacaoUsuario_PSU])
REFERENCES [dbo].[TB_PesquisaSatisfacaoUsuario_PSU] ([SequencialPesquisaSatisfacaoUsuario_PSU])
ALTER TABLE [dbo].[TB_PesquisaSatisfacaoNota_PSN] CHECK CONSTRAINT [FK_TB_PesquisaSatisfacaoNota_PSN_TB_PesquisaSatisfacaoUsuario_PSU]
