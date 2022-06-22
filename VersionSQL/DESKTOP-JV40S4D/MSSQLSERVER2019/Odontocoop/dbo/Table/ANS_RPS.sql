/****** Object:  Table [dbo].[ANS_RPS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ANS_RPS](
	[cd_sequencial] [int] NOT NULL,
	[dt_preparacao] [datetime] NOT NULL,
	[dt_fechado] [datetime] NULL,
	[qt_reg_inclusao] [int] NULL,
	[qt_reg_exclusao] [int] NULL,
	[qt_reg_alteracao] [int] NULL,
	[nossoNumero] [varchar](17) NULL,
	[isencaoOnus] [varchar](1) NULL,
 CONSTRAINT [PK_ANS_RPS] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
