/****** Object:  Table [dbo].[CRMChamadoProtocoloPABX]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMChamadoProtocoloPABX](
	[cpaId] [int] IDENTITY(1,1) NOT NULL,
	[cpaUniqueID] [varchar](50) NULL,
	[chaId] [int] NULL,
	[chaProtocolo] [varchar](30) NOT NULL,
	[chaDtCadastro] [datetime] NOT NULL,
	[ChaDtExclusao] [datetime] NULL,
	[SIP_id] [varchar](20) NULL,
	[SIP_ramal] [varchar](4) NULL,
	[Usuario] [int] NULL,
	[cpaTelefone] [varchar](20) NULL,
	[cpaDtContato] [datetime] NULL,
	[cpaTempoChamada] [datetime] NULL,
	[CD_ASSOCIADO] [int] NULL,
	[cd_Solicitante] [int] NULL,
	[TP_Solicitante] [smallint] NULL,
	[chaDtAlteracao] [datetime] NULL,
	[cpaTipoProtocolo] [smallint] NULL,
 CONSTRAINT [PK_CRMChamadoProtocoloPABX] PRIMARY KEY CLUSTERED 
(
	[cpaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CRMChamadoProtocoloPABX]  WITH NOCHECK ADD  CONSTRAINT [FK_CRMChamadoProtocoloPABX_CRMChamado] FOREIGN KEY([chaId])
REFERENCES [dbo].[CRMChamado] ([chaId])
ALTER TABLE [dbo].[CRMChamadoProtocoloPABX] CHECK CONSTRAINT [FK_CRMChamadoProtocoloPABX_CRMChamado]
