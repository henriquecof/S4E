/****** Object:  Table [dbo].[Lote_Rateio_Intermediadora_Mensalidades]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_Rateio_Intermediadora_Mensalidades](
	[lrmId] [int] IDENTITY(1,1) NOT NULL,
	[lriId] [int] NOT NULL,
	[cd_sequencial_retorno] [int] NOT NULL,
	[nr_linha] [int] NOT NULL,
 CONSTRAINT [PK_Lote_Rateio_Intermediadora_Mensalidades] PRIMARY KEY CLUSTERED 
(
	[lrmId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Lote_Rateio_Intermediadora_Mensalidades]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Rateio_Intermediadora_Mensalidades_Lote_Processos_Bancos_Retorno_Mensalidades] FOREIGN KEY([cd_sequencial_retorno], [nr_linha])
REFERENCES [dbo].[Lote_Processos_Bancos_Retorno_Mensalidades] ([cd_sequencial_retorno], [nr_linha])
ALTER TABLE [dbo].[Lote_Rateio_Intermediadora_Mensalidades] CHECK CONSTRAINT [FK_Lote_Rateio_Intermediadora_Mensalidades_Lote_Processos_Bancos_Retorno_Mensalidades]
ALTER TABLE [dbo].[Lote_Rateio_Intermediadora_Mensalidades]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Rateio_Intermediadora_Mensalidades_Lote_Rateio_Intermediadora] FOREIGN KEY([lriId])
REFERENCES [dbo].[Lote_Rateio_Intermediadora] ([lriId])
ALTER TABLE [dbo].[Lote_Rateio_Intermediadora_Mensalidades] CHECK CONSTRAINT [FK_Lote_Rateio_Intermediadora_Mensalidades_Lote_Rateio_Intermediadora]
