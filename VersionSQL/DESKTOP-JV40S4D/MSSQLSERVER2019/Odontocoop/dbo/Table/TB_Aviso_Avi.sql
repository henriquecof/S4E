/****** Object:  Table [dbo].[TB_Aviso_Avi]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Aviso_Avi](
	[SequencialAviso_Avi] [int] IDENTITY(1,1) NOT NULL,
	[Descricao_Avi] [varchar](150) NOT NULL,
	[Mensagem_Avi] [varchar](5000) NOT NULL,
	[DtCadastro_Avi] [datetime] NOT NULL,
	[DtExclusao_Avi] [datetime] NULL,
 CONSTRAINT [PK_TB_Aviso_Avi] PRIMARY KEY CLUSTERED 
(
	[SequencialAviso_Avi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
