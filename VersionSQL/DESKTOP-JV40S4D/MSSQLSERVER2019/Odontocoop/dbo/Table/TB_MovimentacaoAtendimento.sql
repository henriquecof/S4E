/****** Object:  Table [dbo].[TB_MovimentacaoAtendimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_MovimentacaoAtendimento](
	[Sequencial_MovimentacaoAtendimento] [int] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](50) NOT NULL,
	[Conclui_Atendimento] [smallint] NOT NULL,
 CONSTRAINT [PK_TB_MovimentacaoAtendimento] PRIMARY KEY CLUSTERED 
(
	[Sequencial_MovimentacaoAtendimento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
