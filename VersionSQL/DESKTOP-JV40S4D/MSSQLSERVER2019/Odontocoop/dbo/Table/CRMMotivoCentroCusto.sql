/****** Object:  Table [dbo].[CRMMotivoCentroCusto]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMMotivoCentroCusto](
	[mccId] [int] IDENTITY(1,1) NOT NULL,
	[motId] [smallint] NULL,
	[cd_centro_custo] [smallint] NULL,
 CONSTRAINT [PK_CRMMotivoCentroCusto] PRIMARY KEY CLUSTERED 
(
	[mccId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CRMMotivoCentroCusto]  WITH CHECK ADD  CONSTRAINT [FK_CRMMotivoCentroCusto_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[CRMMotivoCentroCusto] CHECK CONSTRAINT [FK_CRMMotivoCentroCusto_Centro_Custo]
ALTER TABLE [dbo].[CRMMotivoCentroCusto]  WITH CHECK ADD  CONSTRAINT [FK_CRMMotivoCentroCusto_CRMMotivo] FOREIGN KEY([motId])
REFERENCES [dbo].[CRMMotivo] ([motId])
ALTER TABLE [dbo].[CRMMotivoCentroCusto] CHECK CONSTRAINT [FK_CRMMotivoCentroCusto_CRMMotivo]
