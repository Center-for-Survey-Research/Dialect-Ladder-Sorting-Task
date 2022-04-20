<cfscript>

	request.title = "Thank you!";

	queryExecute("
			DECLARE @uid varchar(60) = :uid ; 
			INSERT INTO bent_dialect_paradata (uid, name, value, created) VALUES (@uid, 'completed', '1', getDate())
		"
		,{ "uid":request.id }
		,{datasource="reports22"}
	);
	queryExecute("
			DECLARE @uid varchar(60) = :uid ; 
			UPDATE bent_dialect SET completed = getDate() WHERE uid = @uid
		"
		,{ "uid":request.id }
		,{datasource="reports22"}
	);

</cfscript>
<cfinclude template="../header.cfm">
		<div class="output break">
			<p>Great work. You are all done!</p>
			<p>Thank you!</p>
		</div>
<cfinclude template="../footer.cfm">