/****** Object:  Table [dbo].[TipoRedeAtendimento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoRedeAtendimento](
	[cd_tipo_rede_atendimento] [tinyint] NOT NULL,
	[ds_tipo_rede_atendimento] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoRedeAtendimento] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_rede_atendimento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
