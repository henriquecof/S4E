/****** Object:  Table [dbo].[tbNossosNumeros]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tbNossosNumeros](
	[nnuId] [int] IDENTITY(1,1) NOT NULL,
	[nnuDescricao] [varchar](50) NOT NULL,
	[nnuValor] [int] NOT NULL,
	[nnuPeriodo] [smallint] NULL,
 CONSTRAINT [PK_tbNossosNumeros] PRIMARY KEY CLUSTERED 
(
	[nnuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
