<cfscript>

	if (structKeyExists(form, "submit") and form.submit eq "Continue"){
		location("instructions2.cfm#request.qs()#");
	}

	request.title = "Take a break";

</cfscript>
<cfinclude template="../header.cfm"><cfoutput>
		<div class="output break">
			<p>Take a break. You can start the next block in a few minutes.</p>
			<p class="show60">Press the "Continue" button to move on to the next block.</p>
		</div>
		<div class="next show60">
			<form method="post" action="##">
			<input type="hidden" name="id" value="#request.id#">
			<input type="submit" name="submit" value="Continue" />
			</form>
		</div>
</cfoutput><cfinclude template="../footer.cfm">