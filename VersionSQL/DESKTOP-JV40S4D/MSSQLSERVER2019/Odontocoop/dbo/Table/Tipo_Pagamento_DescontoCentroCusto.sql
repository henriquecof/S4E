/****** Object:  Table [dbo].[Tipo_Pagamento_DescontoCentroCusto]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tipo_Pagamento_DescontoCentroCusto](
	[tdcID] [int] IDENTITY(1,1) NOT NULL,
	[cd_tipo_pagamento] [int] NOT NULL,
	[cd_centro_custo] [smallint] NOT NULL,
	[tdcValor] [money] NULL,
	[tdcDt_Cadastro] [datetime] NULL,
	[tdcUsuarioCadastro] [int] NULL,
	[tdcDt_Exclusao] [datetime] NULL,
	[tdcUsuarioExclusao] [int] NULL,
 CONSTRAINT [PK_Tipo_Pagamento_DescontoCentroCusto] PRIMARY KEY CLUSTERED 
(
	[tdcID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Tipo_Pagamento_DescontoCentroCusto]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_Pagamento_DescontoCentroCusto_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[Tipo_Pagamento_DescontoCentroCusto] CHECK CONSTRAINT [FK_Tipo_Pagamento_DescontoCentroCusto_Centro_Custo]
ALTER TABLE [dbo].[Tipo_Pagamento_DescontoCentroCusto]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_Pagamento_DescontoCentroCusto_TIPO_PAGAMENTO] FOREIGN KEY([cd_tipo_pagamento])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[Tipo_Pagamento_DescontoCentroCusto] CHECK CONSTRAINT [FK_Tipo_Pagamento_DescontoCentroCusto_TIPO_PAGAMENTO]
