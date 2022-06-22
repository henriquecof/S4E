/****** Object:  Table [dbo].[ANS_Arquivo_RedeAtendimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ANS_Arquivo_RedeAtendimento](
	[cd_loteRPS_Rede] [int] IDENTITY(1,1) NOT NULL,
	[dt_gerado] [datetime] NULL,
	[dt_fechado] [datetime] NULL,
	[dt_exclusao] [datetime] NULL,
 CONSTRAINT [PK_ANS_Arquivo_RPS_RedeAtendimento] PRIMARY KEY CLUSTERED 
(
	[cd_loteRPS_Rede] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
