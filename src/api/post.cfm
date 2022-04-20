<cfscript>

if (structKeyExists(form, "submitlist") and form["submitlist"] neq ""){
	f = listToArray(form["submitlist"]);
	for (b in f){
		if (structKeyExists(form, b)){
			a = replaceNoCase(b, "d_", "");
			p = replaceNoCase(form[b],"t_","");
			queryExecute("
				DECLARE @uid varchar(60) = :uid , @page varchar(50) = :page , @audio varchar(50) = :audio , @position varchar(50) = :position ; 
				INSERT INTO bent_dialect_results (uid, page, audio, position, created, finalized)
				VALUES (@uid, @page, @audio, @position, getDate(), 0);"
				,{ "uid":request.id , "page": request.page, "position": p, "audio": a}
				,{datasource="reports22"}
			);
		}		
	}
}

</cfscript>