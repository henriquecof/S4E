/****** Object:  Table [dbo].[PermissaoMenu]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PermissaoMenu](
	[pmId] [tinyint] IDENTITY(1,1) NOT NULL,
	[pmDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_PermissaoMenu] PRIMARY KEY CLUSTERED 
(
	[pmId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
