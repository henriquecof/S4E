/****** Object:  Table [dbo].[Lote_Rateio_Intermediadora]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_Rateio_Intermediadora](
	[lriId] [int] IDENTITY(1,1) NOT NULL,
	[lriUsuarioCadastro] [int] NOT NULL,
	[lriDt_Cadastro] [datetime] NOT NULL,
	[lriCd_Centro_Custo] [smallint] NULL,
 CONSTRAINT [PK_Lote_Rateio_Intermediadora] PRIMARY KEY CLUSTERED 
(
	[lriId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Lote_Rateio_Intermediadora]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Rateio_Intermediadora_Centro_Custo] FOREIGN KEY([lriCd_Centro_Custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[Lote_Rateio_Intermediadora] CHECK CONSTRAINT [FK_Lote_Rateio_Intermediadora_Centro_Custo]
ALTER TABLE [dbo].[Lote_Rateio_Intermediadora]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Rateio_Intermediadora_FUNCIONARIO] FOREIGN KEY([lriUsuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_Rateio_Intermediadora] CHECK CONSTRAINT [FK_Lote_Rateio_Intermediadora_FUNCIONARIO]
