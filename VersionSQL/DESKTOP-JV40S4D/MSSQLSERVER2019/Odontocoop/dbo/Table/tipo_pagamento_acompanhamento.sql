/****** Object:  Table [dbo].[tipo_pagamento_acompanhamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tipo_pagamento_acompanhamento](
	[cd_tipo_pagamento] [int] NOT NULL,
	[data] [date] NOT NULL,
	[saldo_anterior] [money] NOT NULL,
	[faturado] [money] NULL,
	[cancelado] [money] NULL,
	[rec_banco] [money] NULL,
	[rec_caixa] [money] NULL,
	[expurgo] [money] NULL,
	[saldo_final] [money] NULL,
 CONSTRAINT [PK_tipo_pagamento_acompanhamento] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_pagamento] ASC,
	[data] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
