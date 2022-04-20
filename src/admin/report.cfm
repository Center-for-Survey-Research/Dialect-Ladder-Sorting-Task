<cfscript>

	request.title = "Case Management";


	results = queryExecute("
		DECLARE @uid varchar(60) = :uid ; 
		SELECT * FROM bent_dialect_results WHERE uid = @uid ORDER BY page, position;"
		,{ "uid":request.id }
		,{datasource="reports22"}
	);

	pages = ["ladder1","ladder2","ladderR"];
	display = {"ladder1":{"label":"Ladder 1"}, "ladder2":{"label":"Ladder 2"}, "ladderR":{"label":"Ladder R"} };
	for (r in results){
		display[r.page]["a" & r.position] = r.audio;
	}


</cfscript><cfinclude template="../header.cfm"><cfoutput>
<cfloop array="#pages#" index="page">
<div class="ladderOutput">
	  <div id="responses">
	  	<h1>#display[page]["label"]#</h1>
	  	<div id="ladder1">
	  		<cfloop from="1" to="20" index="a">
	  			<div class="ladder">
	  				<cfloop from="1" to="4" index="b">
	  					<div class="option">
	  						<cfif not structKeyExists(display[page], "a#a#_#b#")>
	  							<div class="empty">&nbsp;</div>
	  						<cfelse>
	  							<div class="item">#display[page]["a#a#_#b#"]#</div>
	  						</cfif>
	  					</div>
	  				</cfloop>
	  			</div>
	  		</cfloop>
	  	</div>
	</div>
</div>
</cfloop>
</cfoutput><cfinclude template="../footer.cfm">
