/****** Object:  Table [dbo].[Token]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Token](
	[idToken] [int] IDENTITY(1,1) NOT NULL,
	[idTipoToken] [smallint] NOT NULL,
	[chave] [varchar](50) NOT NULL,
	[dataValidade] [datetime] NULL,
	[idTokenLogin] [int] NULL,
	[empresas] [varchar](50) NULL,
 CONSTRAINT [PK_Token] PRIMARY KEY CLUSTERED 
(
	[idToken] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Token]  WITH CHECK ADD  CONSTRAINT [FK_Token_TipoToken] FOREIGN KEY([idTipoToken])
REFERENCES [dbo].[TipoToken] ([idTipoToken])
ALTER TABLE [dbo].[Token] CHECK CONSTRAINT [FK_Token_TipoToken]
ALTER TABLE [dbo].[Token]  WITH CHECK ADD  CONSTRAINT [FK_TokenLoginToken] FOREIGN KEY([idTokenLogin])
REFERENCES [dbo].[TokenLogin] ([id])
ALTER TABLE [dbo].[Token] CHECK CONSTRAINT [FK_TokenLoginToken]
