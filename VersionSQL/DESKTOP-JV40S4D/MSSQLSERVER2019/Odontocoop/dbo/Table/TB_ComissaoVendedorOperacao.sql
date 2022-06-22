/****** Object:  Table [dbo].[TB_ComissaoVendedorOperacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ComissaoVendedorOperacao](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NULL,
	[Adesao] [smallint] NULL,
	[Operacao] [smallint] NULL,
	[Data_Operacao] [datetime] NULL,
	[valor] [money] NULL,
 CONSTRAINT [PK_TB_ComissaoVendedorOperacao] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
