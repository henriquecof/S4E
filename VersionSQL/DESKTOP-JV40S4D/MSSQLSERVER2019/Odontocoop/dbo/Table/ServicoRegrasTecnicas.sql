/****** Object:  Table [dbo].[ServicoRegrasTecnicas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ServicoRegrasTecnicas](
	[cd_servico] [int] NOT NULL,
	[rteId] [tinyint] NOT NULL,
 CONSTRAINT [PK_ServicoRegrasTecnicas] PRIMARY KEY CLUSTERED 
(
	[cd_servico] ASC,
	[rteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ServicoRegrasTecnicas]  WITH CHECK ADD  CONSTRAINT [FK_ServicoRegrasTecnicas_RegrasTecnicas] FOREIGN KEY([rteId])
REFERENCES [dbo].[RegrasTecnicas] ([rteId])
ALTER TABLE [dbo].[ServicoRegrasTecnicas] CHECK CONSTRAINT [FK_ServicoRegrasTecnicas_RegrasTecnicas]
ALTER TABLE [dbo].[ServicoRegrasTecnicas]  WITH CHECK ADD  CONSTRAINT [FK_ServicoRegrasTecnicas_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[ServicoRegrasTecnicas] CHECK CONSTRAINT [FK_ServicoRegrasTecnicas_SERVICO]
