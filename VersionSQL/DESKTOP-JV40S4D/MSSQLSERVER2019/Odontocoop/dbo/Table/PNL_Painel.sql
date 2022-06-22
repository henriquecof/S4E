/****** Object:  Table [dbo].[PNL_Painel]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PNL_Painel](
	[cd_Painel] [int] IDENTITY(1,1) NOT NULL,
	[nm_Painel] [varchar](50) NULL,
	[status] [bit] NULL,
	[cd_filial] [int] NOT NULL,
 CONSTRAINT [PK_Painel] PRIMARY KEY CLUSTERED 
(
	[cd_Painel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PNL_Painel]  WITH CHECK ADD  CONSTRAINT [FK_Painel_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[PNL_Painel] CHECK CONSTRAINT [FK_Painel_FILIAL]
