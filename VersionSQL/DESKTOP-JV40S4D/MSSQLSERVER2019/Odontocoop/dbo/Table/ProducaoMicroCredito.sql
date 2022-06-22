/****** Object:  Table [dbo].[ProducaoMicroCredito]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ProducaoMicroCredito](
	[idProducao] [int] IDENTITY(1,1) NOT NULL,
	[cd_parcela] [int] NOT NULL,
	[valorComissao] [money] NOT NULL,
	[usuarioCadastro] [int] NULL,
	[dataCadastro] [datetime] NULL,
	[idLote] [int] NULL,
	[usuarioLote] [int] NULL,
	[dataLote] [datetime] NULL,
 CONSTRAINT [PK_ProducaoMicroCredito] PRIMARY KEY CLUSTERED 
(
	[idProducao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProducaoMicroCredito]  WITH CHECK ADD  CONSTRAINT [FK_ProducaoMicroCredito_FUNCIONARIO] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ProducaoMicroCredito] CHECK CONSTRAINT [FK_ProducaoMicroCredito_FUNCIONARIO]
ALTER TABLE [dbo].[ProducaoMicroCredito]  WITH CHECK ADD  CONSTRAINT [FK_ProducaoMicroCredito_FUNCIONARIO1] FOREIGN KEY([usuarioLote])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ProducaoMicroCredito] CHECK CONSTRAINT [FK_ProducaoMicroCredito_FUNCIONARIO1]
ALTER TABLE [dbo].[ProducaoMicroCredito]  WITH CHECK ADD  CONSTRAINT [FK_ProducaoMicroCredito_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[ProducaoMicroCredito] CHECK CONSTRAINT [FK_ProducaoMicroCredito_MENSALIDADES]
