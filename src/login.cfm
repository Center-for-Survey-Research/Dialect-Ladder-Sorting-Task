<cfscript>


	request.title = "Log in";
	audio = [
		"B1F-HINT-09-08"
		,"E3F-HINT-09-08"
		,"E4F-HINT-09-08"
		,"F5F-HINT-09-08"
		,"G5F-HINT-09-08"
		,"I1F-HINT-09-08"
		,"J4F-HINT-09-08"
		,"K3F-HINT-09-08"
		,"M3F-HINT-09-08"
		,"S3F-HINT-09-08"
		,"SC1F-HINT-09-08-Take1"
		,"B1F-HINT-13-07"
		,"E3F-HINT-13-07"
		,"E4F-HINT-13-07"
		,"F5F-HINT-13-07"
		,"G5F-HINT-13-07"
		,"I1F-HINT-13-07"
		,"I4F-HINT-13-07"
		,"K3F-HINT-13-07"
		,"M3F-HINT-13-07"
		,"S3F-HINT-13-07"
		,"SC1F-HINT-13-07-Take1"
		,"B1F-HINT-06-01"
		,"E3F-HINT-11-08"
		,"E4F-HINT-11-10"
		,"F5F-HINT-06-03"
		,"G5F-HINT-06-07"
		,"I1F-HINT-06-10"
		,"J4F-HINT-09-04"
		,"K3F-HINT-10-07"
		,"M3F-HINT-11-06"
		,"S3F-HINT-13-10"
		,"SC1F-HINT-12-06-Take2"
	];	
	CreateObject("java", "java.util.Collections").Shuffle(audio);
	if (structKeyExists(url, "login") and url.login neq ""){
		login = queryExecute("
			DECLARE @loginID varchar(20) = :loginid ;
			SELECT login FROM bent_dialect d WHERE login = @loginID ;
			"
			,{ "loginid" : url.login }
			,{datasource="reports22"}
		);
		if (not login.recordCount){
			url.login = "";
		}
	} else {
		url.login = "";
	}


	if (structKeyExists(form, "login") and form.login neq ""){
		login = queryExecute("
			DECLARE @loginID varchar(20) = :loginid ;
			SELECT d.*, (SELECT COUNT(id) FROM bent_dialect_labels WHERE uid = d.uid) AS labels
			FROM bent_dialect d WHERE login = @loginID ;
			"
			,{ "loginid":form.login }
			,{datasource="reports22"}
		);
		if (not login.recordCount){
			location("index.cfm?error=login");
		}
		id = login.uid;
		assignment = login.group_assignment;
		queryExecute("
			DECLARE @uid varchar(60) = :uid ;
			UPDATE bent_dialect SET first_login = getDate() WHERE uid=@uid AND first_login IS NULL
			"
			,{ "uid":id }
			,{datasource="reports22"}
		);

		if (login.labels eq 0){
			for (a in audio){
				queryExecute("
					DECLARE @uid varchar(60) = :uid , @audio varchar(50) = :audio 
					,@label varchar(5) = CHAR(65+ABS(CHECKSUM(newID())) % 25) + CHAR(65+ABS(CHECKSUM(newID())) % 25);
					INSERT INTO bent_dialect_labels (uid, audio, label, created) VALUES (@uid, @audio, @label, getDate())
					"
					,{ "uid":id, "audio":a }
					,{datasource="reports22"}
				);
			}			
		}
		location(request.url & "/#assignment#/instructions1.cfm?id=#id#");
	}



</cfscript><cfinclude template="header.cfm"><cfoutput>
	<main class="login">
    <form action="login.cfm" method="post">
		<div class="output">
			<p>To begin, enter your login code and press the button below:</p>
			<p><input id="login" type="text" name="login" value="#url.login#" maxlength="20" size="15" />
	        <p><input type="submit" id="login_button" class="login_button" name="submit" value=" Begin " /></p>
	    </div>
    </form>
	</main>
</cfoutput><cfinclude template="footer.cfm">
