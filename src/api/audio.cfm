<cfscript>

if (structKeyExists(form, "submitlist") and form["submitlist"] neq ""){
	f = listToArray(form["submitlist"]);
	for (a in f){
		if (structKeyExists(form, a)){
			queryExecute("
				DECLARE @uid varchar(60) = :uid , @page varchar(50) = :page , @audio varchar(50) = :audio , @action varchar(50) = :action ; 
				INSERT INTO bent_dialect_audio (uid, page, audio, action, created)
				VALUES (@uid, @page, @audio, @action, getDate());"
				,{ "uid":request.id , "page": request.page, "action":"#form[a]#", "audio": a}
				,{datasource="reports22"}
			);
		}		
	}
}

</cfscript>