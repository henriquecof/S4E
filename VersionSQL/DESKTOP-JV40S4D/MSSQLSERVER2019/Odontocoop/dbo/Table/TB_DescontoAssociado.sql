/****** Object:  Table [dbo].[TB_DescontoAssociado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_DescontoAssociado](
	[Sequencial_Desconto] [int] IDENTITY(1,1) NOT NULL,
	[cd_associado] [int] NOT NULL,
	[cd_sequencial] [smallint] NOT NULL,
	[percentual] [decimal](6, 2) NOT NULL,
	[Nome_Usuario] [varchar](10) NOT NULL,
	[Data_UltimaAlteracao] [datetime] NULL,
 CONSTRAINT [PK_TB_DescontoAssociado] PRIMARY KEY CLUSTERED 
(
	[Sequencial_Desconto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_TB_DescontoAssociado] ON [dbo].[TB_DescontoAssociado]
(
	[cd_associado] ASC,
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TB_DescontoAssociado] ADD  CONSTRAINT [DF_TB_DescontoAssociado_Data_UltimaAlteracao]  DEFAULT (getdate()) FOR [Data_UltimaAlteracao]
