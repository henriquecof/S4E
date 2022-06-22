/****** Object:  Table [dbo].[ParametrizacaoFaturamentoFranquias]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ParametrizacaoFaturamentoFranquias](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_empresa] [bigint] NOT NULL,
	[centro_custo] [int] NOT NULL,
	[cd_tipo_parcela] [smallint] NOT NULL,
	[Percentual] [float] NOT NULL,
	[Vencimento] [int] NOT NULL,
	[DataCadastro] [datetime] NOT NULL,
	[cd_tipo_pagamento] [int] NOT NULL,
	[Valor] [money] NULL,
 CONSTRAINT [PK__Parametr__3213E83F08B715E1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ParametrizacaoFaturamentoFranquias]  WITH CHECK ADD  CONSTRAINT [FK_Empresa_cd_empresa_ParametrizacaoFaturamentoFranquias] FOREIGN KEY([cd_empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[ParametrizacaoFaturamentoFranquias] CHECK CONSTRAINT [FK_Empresa_cd_empresa_ParametrizacaoFaturamentoFranquias]
ALTER TABLE [dbo].[ParametrizacaoFaturamentoFranquias]  WITH CHECK ADD  CONSTRAINT [FK_TIPO_PAGAMENTO_cd_tipo_pagamento_ParametrizacaoFaturamentoFranquias] FOREIGN KEY([cd_tipo_pagamento])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[ParametrizacaoFaturamentoFranquias] CHECK CONSTRAINT [FK_TIPO_PAGAMENTO_cd_tipo_pagamento_ParametrizacaoFaturamentoFranquias]
ALTER TABLE [dbo].[ParametrizacaoFaturamentoFranquias]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_parcela_cd_tipo_parcela_ParametrizacaoFaturamentoFranquias] FOREIGN KEY([cd_tipo_parcela])
REFERENCES [dbo].[Tipo_parcela] ([cd_tipo_parcela])
ALTER TABLE [dbo].[ParametrizacaoFaturamentoFranquias] CHECK CONSTRAINT [FK_Tipo_parcela_cd_tipo_parcela_ParametrizacaoFaturamentoFranquias]
