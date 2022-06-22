/****** Object:  Table [dbo].[ProtocoloConsultasRecebimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ProtocoloConsultasRecebimento](
	[idProtocolo] [int] NOT NULL,
	[GTO] [varchar](20) NOT NULL,
	[status] [int] NULL,
 CONSTRAINT [ProtocoloConsultasRecebimento_3] PRIMARY KEY CLUSTERED 
(
	[idProtocolo] ASC,
	[GTO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ProtocoloConsultasRecebimento]  WITH CHECK ADD  CONSTRAINT [ProtocoloConsultasRecebimento_ProtocoloConsultas] FOREIGN KEY([idProtocolo])
REFERENCES [dbo].[ProtocoloConsultas] ([id_protocolo])
ALTER TABLE [dbo].[ProtocoloConsultasRecebimento] CHECK CONSTRAINT [ProtocoloConsultasRecebimento_ProtocoloConsultas]
ALTER TABLE [dbo].[ProtocoloConsultasRecebimento]  WITH CHECK ADD  CONSTRAINT [ProtocoloConsultasRecebimento_ProtocoloConsultasStatus] FOREIGN KEY([status])
REFERENCES [dbo].[ProtocoloConsultasStatus] ([id])
ALTER TABLE [dbo].[ProtocoloConsultasRecebimento] CHECK CONSTRAINT [ProtocoloConsultasRecebimento_ProtocoloConsultasStatus]
