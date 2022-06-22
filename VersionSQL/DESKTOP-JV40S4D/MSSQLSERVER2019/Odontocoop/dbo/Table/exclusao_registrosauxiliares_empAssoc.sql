/****** Object:  Table [dbo].[exclusao_registrosauxiliares_empAssoc]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[exclusao_registrosauxiliares_empAssoc](
	[tp_associado_empresa] [int] NOT NULL,
	[cd_Associado_empresa] [int] NOT NULL,
 CONSTRAINT [PK_exclusao_registrosauxiliares] PRIMARY KEY CLUSTERED 
(
	[tp_associado_empresa] ASC,
	[cd_Associado_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
