﻿/****** Object:  Table [dbo].[LogSenhas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LogSenhas](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrigemInfo] [int] NOT NULL,
	[Codigo] [int] NOT NULL,
	[DtCadastro] [datetime] NOT NULL,
	[Senha] [varchar](50) NOT NULL,
 CONSTRAINT [PK_LogSenhas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
