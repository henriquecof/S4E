/****** Object:  Function [dbo].[FS_MostraFace]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_MostraFace](@cd_ud int,@oclusal bit,@distral bit,@mesial bit,@vestibular bit,@lingual bit)
RETURNS Varchar(15)
AS
Begin
	Declare @WL_Dente Varchar(6)
	Declare @WL_Faces Varchar(15)

	Set @WL_Dente = '%' + convert(varchar,@cd_ud) + '%'
	Set @WL_Faces = ''

	If (@oclusal=1)
		if (PATINDEX (@WL_Dente,',13,12,11,21,22,23,33,32,31,41,42,43,53,52,51,61,62,63,73,72,71,81,82,83,') > 0)
			Set @WL_Faces = @WL_Faces + '(I)'
		else
			Set @WL_Faces = @WL_Faces + '(O)'

	If (@mesial=1)
		Set @WL_Faces = @WL_Faces + '(M)'

	If (@distral=1)
		Set @WL_Faces = @WL_Faces + '(D)'

	If (@vestibular=1)
		Set @WL_Faces = @WL_Faces + '(V)'

	If (@lingual=1)
		if (PATINDEX (@WL_Dente,',18,17,16,15,14,13,12,11,21,22,23,24,25,26,27,28,55,54,53,52,51,61,62,63,64,65,') > 0)
			Set @WL_Faces = @WL_Faces + '(P)'
		else
			Set @WL_Faces = @WL_Faces + '(L)'

	Return @WL_Faces
End
