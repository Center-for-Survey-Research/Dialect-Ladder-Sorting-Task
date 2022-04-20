<cfscript>


	request.title = "Ladder";
	request.page = "ladder2";

	audio = [
		"B1F-HINT-13-07"
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
	];

	if (structKeyExists(form, "submit") and form.submit eq "Yes"){
		for (a = 1; a lte 20; a = a + 1){
			for (b = 1; b lte 4; b = b + 1){
				l = "t_#a#_#b#";
				v = replace(form[l],"d_","");
				if (structKeyExists(form, l) and arrayFind(audio, v)){
					queryExecute("
						DECLARE @uid varchar(60) = :uid , @page varchar(50) = :page , @audio varchar(50) = :audio , @position varchar(50) = :position ; 
						INSERT INTO bent_dialect_results (uid, page, audio, position, created, finalized)
						VALUES (@uid, @page, @audio, @position, getDate(), 1);"
						,{ "uid":request.id , "page": request.page, "position":"#a#_#b#", "audio": v}
						,{datasource="reports22"}
					);
				}
			}
		}
		location("break2.cfm#request.qs()#");
	}

	labels = {};
	for (a in audio){
		labels[a] = left(listFirst(createUUID(), "-"),2);
	}
	ls = queryExecute("
		DECLARE @uid varchar(60) = :uid ; SELECT audio,label FROM bent_dialect_labels WHERE uid=@uid;"
		,{ "uid":request.id }
		,{datasource="reports22"}
	);
	for (l in ls){
		labels[l.audio] = l.label;
	}
	CreateObject("java", "java.util.Collections").Shuffle(audio);


</cfscript><cfinclude template="../header.cfm"><cfoutput>
	<form method="post" action="ladder2.cfm">
		<div class="ladderOutput">
		  <div id="responses">
		  	<div id="ladder1">
		  		<cfloop from="1" to="20" index="a">
		  			<div class="ladder">
		  				<cfloop from="1" to="4" index="b">
		  					<div class="option droppable"><input type="hidden" name="t_#a#_#b#" value="" /></div>
		  				</cfloop>
		  			</div>
		  		</cfloop>
		  	</div>
	  		<div class="label"><p>Sounds like me</p></div>
		  </div>
		  <div id="item-container" class="actions item-container">
		  	<cfloop array="#audio#" index="a">
		  		<div class="container" id="c_#a#">
		  			<div class="item draggable" data-target="##c_#a#" id="d_#a#">
		  				<button class="play" data-play="#a#" id="p_#a#"><span>Play</span></button>&nbsp;&nbsp;&nbsp;#labels[a]#
		  			</div>
		  		</div>
		  	</cfloop>
		 </div>
		</div>
		<div class="audio"><cfloop array="#audio#" index="a"><audio id="#a#" data-player="p_#a#" src="../audio/2/#a#.wav"></audio></cfloop></div>
		<div class="next whenFinished">
			<button class="finished">Finished?</button>
		</div>
		<div class="next whenDone">
			<p>Are you sure?</p>
			<input type="hidden" name="id" value="#request.id#">
			<input type="submit" name="submit" value="Yes" />
			<button>No</button>
		</div>
	</form>
</cfoutput><cfinclude template="../footer.cfm">