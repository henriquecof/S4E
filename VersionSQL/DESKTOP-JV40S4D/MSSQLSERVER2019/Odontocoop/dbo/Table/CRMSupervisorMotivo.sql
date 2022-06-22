/****** Object:  Table [dbo].[CRMSupervisorMotivo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMSupervisorMotivo](
	[motId] [smallint] NOT NULL,
	[cd_funcionario] [int] NOT NULL,
 CONSTRAINT [PK_CRMSupervisorMotivo] PRIMARY KEY CLUSTERED 
(
	[motId] ASC,
	[cd_funcionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CRMSupervisorMotivo]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMSupervisorMotivo_CRMMotivo] FOREIGN KEY([motId])
REFERENCES [dbo].[CRMMotivo] ([motId])
ALTER TABLE [dbo].[CRMSupervisorMotivo] CHECK CONSTRAINT [FK_CRMSupervisorMotivo_CRMMotivo]
