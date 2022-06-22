/****** Object:  Table [dbo].[TB_ReciboAvulso]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ReciboAvulso](
	[SequencialReciboAvulso] [int] IDENTITY(1,1) NOT NULL,
	[Data_Impressao] [smalldatetime] NOT NULL,
	[Numero_Recibo] [varchar](40) NOT NULL,
	[Comentario] [varchar](200) NULL,
	[Data_Recebimento] [smalldatetime] NULL,
	[Sequencial_lancamento] [int] NULL,
	[cd_filial_conta] [int] NOT NULL,
	[nome_usuario] [varchar](20) NULL,
 CONSTRAINT [PK_TB_ReciboAvulso] PRIMARY KEY CLUSTERED 
(
	[SequencialReciboAvulso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_ReciboAvulso]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_ReciboAvulso_TB_Lancamento] FOREIGN KEY([Sequencial_lancamento])
REFERENCES [dbo].[TB_Lancamento] ([Sequencial_Lancamento])
ALTER TABLE [dbo].[TB_ReciboAvulso] CHECK CONSTRAINT [FK_TB_ReciboAvulso_TB_Lancamento]
