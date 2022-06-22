/****** Object:  Table [dbo].[motivo_exclusao_ans]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[motivo_exclusao_ans](
	[cd_motivo_exclusao_ans] [smallint] NOT NULL,
	[ds_motivo_exclusao_ans] [varchar](100) NOT NULL,
	[fl_aceitareativacao] [int] NULL,
 CONSTRAINT [PK_motivo_exclusao_ans] PRIMARY KEY CLUSTERED 
(
	[cd_motivo_exclusao_ans] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
