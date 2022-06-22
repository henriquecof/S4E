/****** Object:  Table [dbo].[CRMSupervisorMotivoDetalhado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMSupervisorMotivoDetalhado](
	[mdeId] [smallint] NOT NULL,
	[cd_funcionario] [int] NOT NULL,
 CONSTRAINT [PK_CRMSupervisorMotivoDetalhado] PRIMARY KEY CLUSTERED 
(
	[mdeId] ASC,
	[cd_funcionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CRMSupervisorMotivoDetalhado]  WITH CHECK ADD  CONSTRAINT [FK_CRMSupervisorMotivoDetalhado_CRMMotivoDetalhado] FOREIGN KEY([mdeId])
REFERENCES [dbo].[CRMMotivoDetalhado] ([mdeId])
ALTER TABLE [dbo].[CRMSupervisorMotivoDetalhado] CHECK CONSTRAINT [FK_CRMSupervisorMotivoDetalhado_CRMMotivoDetalhado]
ALTER TABLE [dbo].[CRMSupervisorMotivoDetalhado]  WITH CHECK ADD  CONSTRAINT [FK_Table_1_FUNCIONARIO] FOREIGN KEY([cd_funcionario])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[CRMSupervisorMotivoDetalhado] CHECK CONSTRAINT [FK_Table_1_FUNCIONARIO]
