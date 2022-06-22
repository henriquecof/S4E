﻿/****** Object:  Table [dbo].[ANS_Retorno_Incluidos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ANS_Retorno_Incluidos](
	[codigoBeneficiario] [varchar](100) NULL,
	[cco] [varchar](100) NULL,
	[nomeBeneficiario] [varchar](100) NULL,
	[cd_sequencial] [int] NULL,
	[cd_pk] [int] IDENTITY(1,1) NOT NULL,
	[mensagem] [varchar](1000) NULL,
 CONSTRAINT [PK_ANS_Retorno_Incluidos] PRIMARY KEY CLUSTERED 
(
	[cd_pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_ANS_Retorno_Incluidos] ON [dbo].[ANS_Retorno_Incluidos]
(
	[codigoBeneficiario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_ANS_Retorno_Incluidos_1] ON [dbo].[ANS_Retorno_Incluidos]
(
	[cco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
