/****** Object:  Table [dbo].[Variavel_Banco_ServicoBancario]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Variavel_Banco_ServicoBancario](
	[cd_banco] [int] NOT NULL,
	[cd_tipo_servico_bancario] [smallint] NOT NULL,
	[variavel] [varchar](50) NOT NULL,
	[valor] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Variavel_TipoPagamento_ServicoBancario] PRIMARY KEY CLUSTERED 
(
	[cd_banco] ASC,
	[cd_tipo_servico_bancario] ASC,
	[variavel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Variavel_Banco_ServicoBancario]  WITH NOCHECK ADD  CONSTRAINT [FK_Variavel_Banco_ServicoBancario_TB_Banco] FOREIGN KEY([cd_banco])
REFERENCES [dbo].[TB_Banco_Contratos] ([cd_banco])
ALTER TABLE [dbo].[Variavel_Banco_ServicoBancario] CHECK CONSTRAINT [FK_Variavel_Banco_ServicoBancario_TB_Banco]
ALTER TABLE [dbo].[Variavel_Banco_ServicoBancario]  WITH NOCHECK ADD  CONSTRAINT [FK_Variavel_Banco_ServicoBancario_tipo_servico_bancario] FOREIGN KEY([cd_tipo_servico_bancario])
REFERENCES [dbo].[tipo_servico_bancario] ([cd_tipo_servico_bancario])
ALTER TABLE [dbo].[Variavel_Banco_ServicoBancario] CHECK CONSTRAINT [FK_Variavel_Banco_ServicoBancario_tipo_servico_bancario]
