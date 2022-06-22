/****** Object:  Table [dbo].[CRMInformacaoAdicional]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMInformacaoAdicional](
	[iadId] [smallint] IDENTITY(1,1) NOT NULL,
	[iadDescricao] [varchar](50) NOT NULL,
	[mdeId] [smallint] NULL,
	[tsrId] [tinyint] NULL,
	[iadAtivo] [bit] NOT NULL,
 CONSTRAINT [PK_CRMInformacaoAdicional] PRIMARY KEY CLUSTERED 
(
	[iadId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CRMInformacaoAdicional]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMInformacaoAdicional_CRMMotivoDetalhado] FOREIGN KEY([mdeId])
REFERENCES [dbo].[CRMMotivoDetalhado] ([mdeId])
ALTER TABLE [dbo].[CRMInformacaoAdicional] CHECK CONSTRAINT [FK_CRMInformacaoAdicional_CRMMotivoDetalhado]
ALTER TABLE [dbo].[CRMInformacaoAdicional]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMInformacaoAdicional_CRMTipoStatusResultado] FOREIGN KEY([tsrId])
REFERENCES [dbo].[CRMTipoStatusResultado] ([tsrId])
ALTER TABLE [dbo].[CRMInformacaoAdicional] CHECK CONSTRAINT [FK_CRMInformacaoAdicional_CRMTipoStatusResultado]
