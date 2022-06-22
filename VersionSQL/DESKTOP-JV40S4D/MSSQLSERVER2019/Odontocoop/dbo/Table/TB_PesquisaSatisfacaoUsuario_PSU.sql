/****** Object:  Table [dbo].[TB_PesquisaSatisfacaoUsuario_PSU]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_PesquisaSatisfacaoUsuario_PSU](
	[SequencialPesquisaSatisfacaoUsuario_PSU] [int] IDENTITY(1,1) NOT NULL,
	[cd_associado] [int] NULL,
	[cd_empresa] [int] NULL,
	[cd_sequencial_agenda] [int] NULL,
	[DtInclusao_PSU] [datetime] NOT NULL,
 CONSTRAINT [PK_TB_PesquisaSatisfacaoUsuario_PSU] PRIMARY KEY CLUSTERED 
(
	[SequencialPesquisaSatisfacaoUsuario_PSU] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_PesquisaSatisfacaoUsuario_PSU]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_PesquisaSatisfacaoUsuario_PSU_ASSOCIADOS] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[TB_PesquisaSatisfacaoUsuario_PSU] CHECK CONSTRAINT [FK_TB_PesquisaSatisfacaoUsuario_PSU_ASSOCIADOS]
