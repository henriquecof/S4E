/****** Object:  Table [dbo].[CRMSolicitacaoCancelamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMSolicitacaoCancelamento](
	[chaId] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
 CONSTRAINT [PK_CRMSolicitacaoCancelamento] PRIMARY KEY CLUSTERED 
(
	[chaId] ASC,
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
