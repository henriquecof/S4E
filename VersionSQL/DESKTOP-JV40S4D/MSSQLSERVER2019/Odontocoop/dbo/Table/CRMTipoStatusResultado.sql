/****** Object:  Table [dbo].[CRMTipoStatusResultado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMTipoStatusResultado](
	[tsrId] [tinyint] NOT NULL,
	[tsrDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CRMTipoStatusResultado] PRIMARY KEY CLUSTERED 
(
	[tsrId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
