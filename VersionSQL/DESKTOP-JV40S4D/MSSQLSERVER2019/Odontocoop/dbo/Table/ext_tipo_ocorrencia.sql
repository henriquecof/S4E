﻿/****** Object:  Table [dbo].[ext_tipo_ocorrencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ext_tipo_ocorrencia](
	[id_ext_tipo_ocorrencia] [int] IDENTITY(1,1) NOT NULL,
	[tipo_ocorrencia] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ext_tipo_ocorrencia] PRIMARY KEY CLUSTERED 
(
	[id_ext_tipo_ocorrencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
