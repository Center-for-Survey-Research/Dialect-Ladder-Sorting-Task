<cfscript>


	if (structKeyExists(form, "submit") and form.submit eq "Next"){

		location("ladder2.cfm#request.qs()#");
	}

	request.title = "Instructions";


</cfscript>
<cfinclude template="../header.cfm"><cfoutput>
		<div class="output">
			<p>Now, we're going to do the same thing again, but the people will be saying a different sentence. You should move the boxes around, just like last time.</p>
			<p>Press "Next" to begin.</p>
		</div>
		<div class="next">
			<form method="post" action="##">
			<input type="hidden" name="id" value="#request.id#">
			<input type="submit" name="submit" value="Next" />
			</form>
		</div>
</cfoutput><cfinclude template="../footer.cfm">