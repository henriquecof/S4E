/****** Object:  Table [dbo].[Filial_meta]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Filial_meta](
	[cd_filial] [int] NOT NULL,
	[clinico] [money] NOT NULL,
	[contratos] [money] NOT NULL,
	[ortodontia] [money] NOT NULL,
	[qtde_Manutencao] [int] NULL,
	[qtde_Contrato] [int] NULL,
	[vl_Protese] [money] NULL,
	[vl_Implante] [money] NULL,
	[vl_OutrosMateriais] [money] NULL,
	[qtde_DiasUteis] [smallint] NULL,
	[DiasUteis] [varchar](100) NULL,
	[qtde_ContratosEsteticos] [int] NULL,
	[faturamentoTotal] [money] NULL,
	[vl_CampanhaVendas] [money] NULL,
	[novosCadastros] [int] NULL,
	[percOrcamentosIniciaisPagos] [money] NULL,
	[percOrcamentosAnterioresPagos] [money] NULL,
	[recuperadoPosVenda] [money] NULL,
	[pacienteOrtoAgendamento] [money] NULL,
	[pagamentoAdesao] [money] NULL,
 CONSTRAINT [PK_Filial_meta] PRIMARY KEY CLUSTERED 
(
	[cd_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
