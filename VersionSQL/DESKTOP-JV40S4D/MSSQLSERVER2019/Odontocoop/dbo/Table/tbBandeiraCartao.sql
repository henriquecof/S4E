/****** Object:  Table [dbo].[tbBandeiraCartao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tbBandeiraCartao](
	[bcaId] [smallint] IDENTITY(1,1) NOT NULL,
	[bcaDescricao] [varchar](50) NULL,
	[bcaAtivo] [bit] NULL,
 CONSTRAINT [PK_tbBandeiraCartao] PRIMARY KEY CLUSTERED 
(
	[bcaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
