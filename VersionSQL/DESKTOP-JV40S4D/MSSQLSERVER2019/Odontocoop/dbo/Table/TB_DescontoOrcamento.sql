/****** Object:  Table [dbo].[TB_DescontoOrcamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_DescontoOrcamento](
	[Sequencial_DescontoOrcamento] [int] IDENTITY(1,1) NOT NULL,
	[cd_associado] [int] NOT NULL,
	[cd_sequencial] [int] NOT NULL,
	[percentual] [decimal](6, 2) NOT NULL,
	[Juros] [smallint] NOT NULL,
	[Data_LimiteDesconto] [datetime] NULL,
	[Nome_Usuario] [varchar](10) NOT NULL,
	[valor_parcela] [decimal](18, 2) NULL,
 CONSTRAINT [PK_TB_DescontoOrcamento] PRIMARY KEY CLUSTERED 
(
	[Sequencial_DescontoOrcamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
