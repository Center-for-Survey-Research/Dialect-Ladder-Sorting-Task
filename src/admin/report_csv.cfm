<cfsetting showDebugOutput = "no" ><cfscript>

	if (not structKeyExists(url, "uid")) url.uid = ""; 


	r = queryExecute("
		DECLARE @uid varchar(60) = nullIf( :uid , '' ) ; 
		SELECT b.uid,b.sample_code,b.login,b.group_assignment,b.created,b.first_login,r.page,r.audio,l.label,r.position,r.created AS added,r.finalized,isNull(p.value,0) AS completed  FROM 
		bent_dialect b INNER JOIN
		bent_dialect_results r ON b.uid=r.uid INNER JOIN
		bent_dialect_labels l ON b.uid=l.uid AND r.audio=l.audio LEFT OUTER JOIN
		bent_dialect_paradata p ON b.uid=p.uid
		WHERE (p.name = 'completed' OR p.name IS NULL) AND (b.uid = @uid OR @uid IS NULL) AND finalized=1
		ORDER BY r.uid
		,CASE WHEN r.page = 'Ladder1' THEN 1
		              WHEN page = 'Ladder2' THEN 2
		              ELSE 3 END
		,r.audio
		"
		,{ "uid" : url.uid}
		,{datasource="reports22"}
	);


</cfscript><cfsavecontent variable="csvFile"><cfoutput>UID,SAMPLE_CODE,LOGIN,GROUP_ASSIGNMENT,COMPLETED,LOGIN_CREATED,FIRST_LOGIN,PAGE,AUDIO_FILE,LABEL,POSITION,DECISION_DATE
<cfloop query="#r#">"#r.uid#","#r.sample_code#","#r.login#","#r.group_assignment#","#r.completed#","#dateFormat(r.created,"m/d/yy")# #timeFormat(r.created,"hh:mm")#","#dateFormat(r.first_login,"m/d/yy")# #timeFormat(r.first_login,"hh:mm")#","#r.page#","#r.audio#","#r.label#","#r.position#","#dateFormat(r.added,"m/d/yy")# #timeFormat(r.added,"hh:mm")#"
</cfloop></cfoutput></cfsavecontent><cfscript>

	filename = "bent_dialect_history_";
	if (url.uid neq ""){
		filename &= "#url.uid#_";
	}
	filename &= "#dateFormat(now(),"yyyymmdd")##timeFormat(now(),"HHmmss")#.csv";


	cfheader(name="Content-disposition", value="attachment;filename=#filename#");
	cfcontent( reset="yes", type="text/csv; charset=iso-8859-1"); 
	writeOutput(csvFile);
	abort;

</cfscript>