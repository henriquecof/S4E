/****** Object:  Table [dbo].[tbRetornoCielo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tbRetornoCielo](
	[rciId] [int] IDENTITY(1,1) NOT NULL,
	[rciTID] [varchar](50) NULL,
	[rciLR] [varchar](50) NULL,
	[rciARP] [varchar](50) NULL,
	[rciARS] [varchar](500) NULL,
	[rciPRICE] [money] NULL,
	[rciFREE] [varchar](50) NULL,
	[rciPAN] [varchar](50) NULL,
	[rciAUTHENT] [varchar](50) NULL,
	[comId] [int] NULL,
	[rciChave] [varchar](50) NULL,
	[rciDtCadastro] [datetime] NULL,
 CONSTRAINT [PK_tbRetornoCielo] PRIMARY KEY CLUSTERED 
(
	[rciId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
