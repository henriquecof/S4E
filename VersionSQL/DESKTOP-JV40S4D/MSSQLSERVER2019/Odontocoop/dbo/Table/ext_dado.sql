/****** Object:  Table [dbo].[ext_dado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ext_dado](
	[id_ext_dado] [int] IDENTITY(1,1) NOT NULL,
	[cpf] [varchar](45) NOT NULL,
	[log] [datetime] NOT NULL,
	[data_exclusao] [datetime] NULL,
	[id_tipo_servico_externo] [tinyint] NULL,
 CONSTRAINT [ext_dado_1_3] PRIMARY KEY CLUSTERED 
(
	[id_ext_dado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
