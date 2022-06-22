/****** Object:  Table [dbo].[EmpresaAlteracaoLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmpresaAlteracaoLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[funcionario] [int] NULL,
	[empresa] [bigint] NULL,
	[dataAlteracao] [datetime] NULL,
 CONSTRAINT [PK_EmpresaAlteracaoLog_3] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[EmpresaAlteracaoLog]  WITH CHECK ADD  CONSTRAINT [FK_EmpresaAlteracaoLog_EMPRESA] FOREIGN KEY([empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[EmpresaAlteracaoLog] CHECK CONSTRAINT [FK_EmpresaAlteracaoLog_EMPRESA]
ALTER TABLE [dbo].[EmpresaAlteracaoLog]  WITH CHECK ADD  CONSTRAINT [FK_EmpresaAlteracaoLog_FUNCIONARIO1] FOREIGN KEY([funcionario])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[EmpresaAlteracaoLog] CHECK CONSTRAINT [FK_EmpresaAlteracaoLog_FUNCIONARIO1]
