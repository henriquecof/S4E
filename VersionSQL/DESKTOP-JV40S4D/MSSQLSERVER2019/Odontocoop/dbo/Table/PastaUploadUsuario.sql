/****** Object:  Table [dbo].[PastaUploadUsuario]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PastaUploadUsuario](
	[puuId] [int] IDENTITY(1,1) NOT NULL,
	[puuPasta] [varchar](500) NOT NULL,
	[UsuarioCadastro] [int] NOT NULL,
	[puuDtCadastro] [datetime] NOT NULL,
 CONSTRAINT [PK_PastaUploadUsuario] PRIMARY KEY CLUSTERED 
(
	[puuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PastaUploadUsuario]  WITH CHECK ADD  CONSTRAINT [FK_PastaUploadUsuario_FUNCIONARIO] FOREIGN KEY([UsuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[PastaUploadUsuario] CHECK CONSTRAINT [FK_PastaUploadUsuario_FUNCIONARIO]
