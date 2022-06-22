/****** Object:  Table [dbo].[ramo_atividade]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ramo_atividade](
	[cd_ramo_atividade] [smallint] IDENTITY(1,1) NOT NULL,
	[nm_ramo_atividade] [varchar](50) NULL,
 CONSTRAINT [PK_ramo_atividade] PRIMARY KEY CLUSTERED 
(
	[cd_ramo_atividade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
