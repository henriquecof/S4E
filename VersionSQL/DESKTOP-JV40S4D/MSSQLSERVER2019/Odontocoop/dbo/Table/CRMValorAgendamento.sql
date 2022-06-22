/****** Object:  Table [dbo].[CRMValorAgendamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMValorAgendamento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[chaId] [int] NOT NULL,
	[valorAgendamento] [money] NOT NULL,
 CONSTRAINT [PK_CRMValorAgendamento] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CRMValorAgendamento]  WITH CHECK ADD  CONSTRAINT [FK_CRMValorAgendamento_CRMChamado] FOREIGN KEY([chaId])
REFERENCES [dbo].[CRMChamado] ([chaId])
ALTER TABLE [dbo].[CRMValorAgendamento] CHECK CONSTRAINT [FK_CRMValorAgendamento_CRMChamado]
