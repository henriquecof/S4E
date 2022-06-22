/****** Object:  Table [dbo].[LogNavegacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LogNavegacao](
	[lnaId] [int] IDENTITY(1,1) NOT NULL,
	[tlnId] [int] NOT NULL,
	[lnaDtCadastro] [datetime] NOT NULL,
	[cd_empresa] [int] NULL,
	[cd_sequencial_dep] [int] NULL,
	[cd_parcela] [int] NULL,
 CONSTRAINT [PK_LogNavegacao] PRIMARY KEY CLUSTERED 
(
	[lnaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
