/****** Object:  Table [dbo].[TB_DescontoAgendado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_DescontoAgendado](
	[Sequencial_DescontoAgendado] [int] IDENTITY(1,1) NOT NULL,
	[Data_inicial] [datetime] NOT NULL,
	[Data_Final] [datetime] NOT NULL,
	[Motivo_Desconto_Padrao] [varchar](500) NOT NULL,
	[Valor] [money] NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[data_horaexclusao] [datetime] NULL,
 CONSTRAINT [PK_TB_DescontoAgendado] PRIMARY KEY CLUSTERED 
(
	[Sequencial_DescontoAgendado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
