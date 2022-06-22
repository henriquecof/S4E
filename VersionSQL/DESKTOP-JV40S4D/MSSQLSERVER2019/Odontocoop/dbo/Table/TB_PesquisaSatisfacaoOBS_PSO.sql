/****** Object:  Table [dbo].[TB_PesquisaSatisfacaoOBS_PSO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_PesquisaSatisfacaoOBS_PSO](
	[SequencialPesquisaSatisfacaoOBS_PSO] [int] IDENTITY(1,1) NOT NULL,
	[SequencialPesquisaSatisfacaoUsuario_PSU] [int] NOT NULL,
	[Observacao_PSO] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_TB_PesquisaSatisfacaoOBS_PSO] PRIMARY KEY CLUSTERED 
(
	[SequencialPesquisaSatisfacaoOBS_PSO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_PesquisaSatisfacaoOBS_PSO]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_PesquisaSatisfacaoOBS_PSO_TB_PesquisaSatisfacaoUsuario_PSU] FOREIGN KEY([SequencialPesquisaSatisfacaoUsuario_PSU])
REFERENCES [dbo].[TB_PesquisaSatisfacaoUsuario_PSU] ([SequencialPesquisaSatisfacaoUsuario_PSU])
ALTER TABLE [dbo].[TB_PesquisaSatisfacaoOBS_PSO] CHECK CONSTRAINT [FK_TB_PesquisaSatisfacaoOBS_PSO_TB_PesquisaSatisfacaoUsuario_PSU]
