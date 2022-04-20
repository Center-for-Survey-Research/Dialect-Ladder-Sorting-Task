<cfscript>

	request.title = "Case Management";



	if (structKeyExists(form, "submit") and form.submit neq ""){
		id = createUUID();
		sample_code = "";
		if (structKeyExists(form, "sample_code") and form.sample_code neq "") sample_code = trim(form.sample_code);
		login_code = "";
		if (structKeyExists(form, "login_code") and form.login_code neq "") login_code = trim(form.login_code);
		group = "";
		if (structKeyExists(form, "group") and form.group neq ""){
			group = form.group;
		} else {
			group = "A";
			if (randRange(0,100) gt 50) { group = "B"; }
		}


		check_constraints = queryExecute("
				DECLARE @sample_code varchar(50) = :sample_code , @login varchar(50) = :login ;
				SELECT uid 
				FROM bent_dialect d
				WHERE sample_code = @sample_code OR login = @login;
			"
			,{ "sample_code":sample_code, "login":login_code}
			,{datasource="reports22"}
		);
		if (check_constraints.recordCount){
			location("index.cfm?error=unique");
		}



		queryExecute("
			DECLARE @uid varchar(60) = :uid , @sample_code varchar(50) = :sample_code , @group varchar(5) = :group ;
			INSERT INTO bent_dialect (uid, sample_code, group_assignment, created) VALUES (@uid, @sample_code, @group, getDate());
			"
			,{ "uid":id, "sample_code":sample_code, "group":group }
			,{datasource="reports22"}
		);
		if (login_code neq ""){
			queryExecute("
				DECLARE @uid varchar(60) = :uid , @login varchar(50) = :login ;
				UPDATE bent_dialect SET login = @login WHERE uid=@uid;
				"
				,{ "uid":id, "login":login_code }
				,{datasource="reports22"}
			);
		}
		location("index.cfm");
	}



	r = queryExecute("
			SELECT 
				d.*
				,(SELECT TOP 1 created FROM bent_dialect_paradata WHERE uid = d.uid AND name='completed' ORDER BY id DESC) AS finished
			FROM bent_dialect d
			ORDER BY finished DESC, first_login DESC, uid
		"
		,{ }
		,{datasource="reports22"}
	);

</cfscript><cfinclude template="../header.cfm"><cfoutput>
	<cfif structKeyExists(url, "error") and url.error eq "unique"><div class="error">The Sample ID and Login Code must be unique. Please update those and try again.</div></cfif>
	<main class="admin">
		<h3><a href="report_csv.cfm">Download CSV</a></h3>
		<table>
			<thead>
				<tr>
					<th>UID</th>
					<th>Sample&nbsp;ID</th>
					<th>Login&nbsp;Code</th>
					<th>Group&nbsp;Assignment</th>
					<th>First&nbsp;Login</th>
					<th>Completed</th>
					<th>Data&nbsp;Download</th>
					<th>Complete&nbsp;History</th>
				</tr>
			</thead>
			<tbody>
				<form action="index.cfm" method="post">
				<tr>
					<td>&nbsp;</td>
					<td><input type="text" name="sample_code" value="" /></td>
					<td><input type="text" name="login_code" value="" /></td>
					<td><select name="group"><option value="">Random</option><option value="A">A</option><option value="B">B</option></select></td>
					<td><input type="submit" name="submit" value="Add" class="sample" /></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				</form>
<cfloop query="r">
				<tr>
					<td>#r.uid#</td>
					<td>#r.sample_code#</td>
					<td><a href="../login.cfm?login=#encodeForURL(r.login)#" target="l">#r.login#</a></td>
					<td>#r.group_assignment#</td>
					<td>#dateFormat(r.first_login, "m/d/yyyy")# #timeFormat(r.first_login, "hh:mm tt")#</td>
					<td><cfif r.finished eq "">&nbsp;<cfelse><a href="report.cfm?id=#r.uid#" target="r">#dateFormat(r.finished, "m/d/yyyy")# #timeFormat(r.finished, "hh:mm tt")#</a></cfif></td>
					<td><a href="report_csv.cfm?uid=#encodeForURL(r.uid)#">CSV</a></td>
					<td><a href="history_csv.cfm?uid=#encodeForURL(r.uid)#">CSV</a></td>
				</tr>
</cfloop>
			</tbody>
		</table>
	</main>
</cfoutput><cfinclude template="../footer.cfm">
