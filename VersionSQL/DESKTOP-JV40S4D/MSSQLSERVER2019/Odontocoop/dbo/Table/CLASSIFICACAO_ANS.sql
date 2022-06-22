﻿/****** Object:  Table [dbo].[CLASSIFICACAO_ANS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CLASSIFICACAO_ANS](
	[cd_classificacao] [smallint] IDENTITY(1,1) NOT NULL,
	[ds_classificacao] [varchar](50) NOT NULL,
	[cd_ans] [varchar](10) NULL,
	[tp_empresa] [smallint] NULL,
	[splId] [tinyint] NULL,
	[cd_abrangencia] [int] NULL,
	[rplId] [tinyint] NULL,
	[IdConvenio] [int] NULL,
	[formacaoPreco] [tinyint] NULL,
 CONSTRAINT [PK_CLASSIFICACAO_ANS] PRIMARY KEY CLUSTERED 
(
	[cd_classificacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE UNIQUE NONCLUSTERED INDEX [IX_CLASSIFICACAO_ANS] ON [dbo].[CLASSIFICACAO_ANS]
(
	[cd_ans] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CLASSIFICACAO_ANS]  WITH CHECK ADD  CONSTRAINT [FK_CLASSIFICACAO_ANS_Abrangencia] FOREIGN KEY([cd_abrangencia])
REFERENCES [dbo].[Abrangencia] ([cd_abrangencia])
ALTER TABLE [dbo].[CLASSIFICACAO_ANS] CHECK CONSTRAINT [FK_CLASSIFICACAO_ANS_Abrangencia]
ALTER TABLE [dbo].[CLASSIFICACAO_ANS]  WITH CHECK ADD  CONSTRAINT [FK_CLASSIFICACAO_ANS_CONVENIO] FOREIGN KEY([IdConvenio])
REFERENCES [dbo].[Convenio] ([Id])
ALTER TABLE [dbo].[CLASSIFICACAO_ANS] CHECK CONSTRAINT [FK_CLASSIFICACAO_ANS_CONVENIO]
ALTER TABLE [dbo].[CLASSIFICACAO_ANS]  WITH CHECK ADD  CONSTRAINT [FK_classificacao_ans_RegulamentacaoPlano] FOREIGN KEY([rplId])
REFERENCES [dbo].[RegulamentacaoPlano] ([rplId])
ALTER TABLE [dbo].[CLASSIFICACAO_ANS] CHECK CONSTRAINT [FK_classificacao_ans_RegulamentacaoPlano]
ALTER TABLE [dbo].[CLASSIFICACAO_ANS]  WITH CHECK ADD  CONSTRAINT [FK_CLASSIFICACAO_ANS_SituacaoPlano] FOREIGN KEY([splId])
REFERENCES [dbo].[SituacaoPlano] ([splId])
ALTER TABLE [dbo].[CLASSIFICACAO_ANS] CHECK CONSTRAINT [FK_CLASSIFICACAO_ANS_SituacaoPlano]
ALTER TABLE [dbo].[CLASSIFICACAO_ANS]  WITH NOCHECK ADD  CONSTRAINT [FK_CLASSIFICACAO_ANS_TIPO_EMPRESA] FOREIGN KEY([tp_empresa])
REFERENCES [dbo].[TIPO_EMPRESA] ([tp_empresa])
ALTER TABLE [dbo].[CLASSIFICACAO_ANS] CHECK CONSTRAINT [FK_CLASSIFICACAO_ANS_TIPO_EMPRESA]