/****** Object:  Table [dbo].[LotesConsultasCadSus]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LotesConsultasCadSus](
	[idLote] [int] IDENTITY(1,1) NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[qtdeAtivosSemCNS] [int] NULL,
	[qtdeConsultasCNS] [int] NULL,
	[qtdeConfirmadosCNS] [int] NULL,
 CONSTRAINT [PK_LotesConsultasCadSus] PRIMARY KEY CLUSTERED 
(
	[idLote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
