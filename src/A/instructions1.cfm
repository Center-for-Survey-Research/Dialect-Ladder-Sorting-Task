<cfscript>


	if (structKeyExists(form, "submit") and form.submit eq "Next"){

		location("ladder1.cfm#request.qs()#");
	}

	request.title = "Instructions";


</cfscript>
<cfinclude template="../header.cfm"><cfoutput>
		<div class="output">
			<p>For this game, you are going to listen to different people saying the same sentence. Some people will sound like you; some people will sound different from you. When you click and hold on one of these boxes, you'll hear one of the people saying that sentence. After you listen to the sentence, you get to move the boxes around so that the people talking who sound like you are near the bottom. People who sound really different from you should be at the top. And people who are in-between should be in the middle.</p>
			<p>Press "Next" to begin.</p>
		</div>
		<div class="next">
			<form method="post" action="instructions1.cfm">
			<input type="hidden" name="id" value="#request.id#">
			<input type="submit" name="submit" value="Next" />
			</form>
		</div>
</cfoutput><cfinclude template="../footer.cfm">