/****** Object:  Table [dbo].[RegrasCancelamentoDependente]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[RegrasCancelamentoDependente](
	[cd_regra] [int] NOT NULL,
	[nm_regra] [varchar](200) NOT NULL,
 CONSTRAINT [PK_RegrasCancelamentoDependente] PRIMARY KEY CLUSTERED 
(
	[cd_regra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
