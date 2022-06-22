/****** Object:  Table [dbo].[funcionario_faixa]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[funcionario_faixa](
	[cd_faixa] [int] NOT NULL,
	[nm_faixa] [nvarchar](50) NULL,
	[vl_faixa] [money] NULL,
 CONSTRAINT [PK_funcionario_faixa] PRIMARY KEY CLUSTERED 
(
	[cd_faixa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
