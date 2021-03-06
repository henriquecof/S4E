/****** Object:  Table [dbo].[ANS_Retorno_Rejeitados]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ANS_Retorno_Rejeitados](
	[tipoMovimento] [varchar](100) NULL,
	[cco] [varchar](100) NULL,
	[codigoBeneficiario] [varchar](100) NULL,
	[mensagemErro] [varchar](1000) NULL,
	[cd_sequencial] [int] NULL,
	[cd_pk] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_ANS_Retorno_Rejeitados] PRIMARY KEY CLUSTERED 
(
	[cd_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_ANS_Retorno_Rejeitados] ON [dbo].[ANS_Retorno_Rejeitados]
(
	[codigoBeneficiario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_ANS_Retorno_Rejeitados_1] ON [dbo].[ANS_Retorno_Rejeitados]
(
	[cco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
