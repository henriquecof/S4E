/****** Object:  Table [dbo].[Bandeira]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Bandeira](
	[cd_bandeira] [smallint] NOT NULL,
	[ds_bandeira] [varchar](100) NULL,
	[tipo] [char](1) NULL,
	[qtdl_digitosCartao] [tinyint] NULL,
	[digitoVerificadorAgencia] [bit] NULL,
	[digitoVerificadorConta] [bit] NULL,
 CONSTRAINT [PK_Bandeira] PRIMARY KEY CLUSTERED 
(
	[cd_bandeira] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
