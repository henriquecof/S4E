/****** Object:  Procedure [dbo].[SP_CriaIndice]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_CriaIndice] (@bd int)
as 
Begin 

	--select * from sys.databases 

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_Fragmentation]') AND type in (N'U'))
	Begin
	   drop table tbl_Fragmentation
	End    

	Create table tbl_Fragmentation (db int, objeto int, indice int, perc float)

	Declare @nome varchar(200)
	Declare @id_tab int 
	Declare @SQL varchar(max)

	DECLARE cursor_tab CURSOR FOR  
	select top 20 name, object_id from sys.tables 
	  OPEN cursor_tab  
	 FETCH NEXT FROM cursor_tab INTO @nome,@id_tab
	WHILE (@@FETCH_STATUS <> -1)  
	begin  -- Inicio Cursor

	   insert tbl_Fragmentation
	   SELECT database_id,	object_id,	index_id ,avg_fragmentation_in_percent   
	     FROM sys.dm_db_index_physical_stats (@bd, @id_tab, null, NULL, null);

	   FETCH NEXT FROM cursor_tab INTO @nome,@id_tab
	End 
	Close cursor_tab
	Deallocate cursor_tab   

    DECLARE cursor_SQL CURSOR FOR  
	 select 'alter index ' + i.name + ' on ' + t.name + ' rebuild ' -- , t1.*
	   from tbl_Fragmentation as t1, sys.tables as t , sys.indexes as i
	   where perc>40 and t1.objeto = t.object_id
		 and t1.objeto = i.object_id and t1.indice = i.index_id
		 and indice > 0 
	  OPEN cursor_SQL  
		 FETCH NEXT FROM cursor_SQL INTO @SQL
		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- Inicio Cursor
		   print @SQL
		   exec (@SQL)
		   
		   FETCH NEXT FROM cursor_SQL INTO @SQL
		End    
      close cursor_SQL
      Deallocate cursor_SQL
End  
