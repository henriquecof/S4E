/****** Object:  Table [dbo].[PNL_ChamadaPainel]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PNL_ChamadaPainel](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[nm_chamado] [varchar](200) NULL,
	[dt_chamadaPainel] [datetime] NULL,
	[dt_inclusaoFila] [datetime] NULL,
	[dt_execucaoPainel] [datetime] NULL,
	[cd_PainelFila_LocalAtendimento] [int] NULL,
	[cd_funcionario_inclusao] [int] NOT NULL,
	[fl_ChamadaManual] [bit] NULL,
 CONSTRAINT [PK_Painel_ChamadaPainel] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PNL_ChamadaPainel]  WITH CHECK ADD  CONSTRAINT [FK_PNL_ChamadaPainel_PNL_PainelFila_LocalAtendimento] FOREIGN KEY([cd_PainelFila_LocalAtendimento])
REFERENCES [dbo].[PNL_PainelFila_LocalAtendimento] ([cd_sequencial])
ALTER TABLE [dbo].[PNL_ChamadaPainel] CHECK CONSTRAINT [FK_PNL_ChamadaPainel_PNL_PainelFila_LocalAtendimento]
