<cfscript>


	if (structKeyExists(form, "submit") and form.submit eq "Next"){

		location("ladderR.cfm#request.qs()#","no");
	}

	request.title = "Instructions";


</cfscript>
<cfinclude template="../header.cfm"><cfoutput>
		<div class="output">
			<p>We're going to do this one more time. Now, all the people will be saying different things. You should still move the boxes around based on who sounds like you and who sounds different than you.</p>
			<p>Press "Next" to begin.</p>
		</div>
		<div class="next">
			<form method="post" action="##">
			<input type="hidden" name="id" value="#request.id#">
			<input type="submit" name="submit" value="Next" />
			</form>
		</div>
</cfoutput><cfinclude template="../footer.cfm">