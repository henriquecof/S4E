﻿/****** Object:  Table [dbo].[DIA_PAGAMENTO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[DIA_PAGAMENTO](
	[cd_dia] [smallint] NOT NULL,
	[ds_dia] [varchar](2) NULL,
 CONSTRAINT [PK_DIA_PAGAMENTO] PRIMARY KEY NONCLUSTERED 
(
	[cd_dia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
