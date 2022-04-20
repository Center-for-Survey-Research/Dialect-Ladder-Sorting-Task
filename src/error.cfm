<cfprocessingdirective suppresswhitespace="yes">
<cfsetting enablecfoutputonly="no">
<cfinclude template="header.cfm">
<!---
should identify the program that is posting the error message
should alert the customer to the specific problem
should provide some specific indication as to how the problem may be solved
should suggest where the customer may obtain further help
should provide extra information to the person who is helping the customer
should not suggest an action that will fail to solve the problem and thus waste the customer�s time
should not contain information that is unhelpful, redundant, incomplete, or inaccurate
should provide an identifying code to distinguish it from other, similar messages

--->
<cfoutput>
	<h2>We&rsquo;re sorry, but something unexpected has happened. We&rsquo;re not sure of the exact problem, but we will look into it right away and contact you when it is fixed. Thank you for your patience.</h2>
	<h2>In the meantime, if you have questions, please <a href="#request.root#/includes/contactUs.cfm">contact us</a>.</h2>
</cfoutput>
<cfsavecontent variable="emailText">
<cfoutput><cfif isDefined("EventName")><h2>Event:</h2><cfdump var="#EventName#" format="text"></cfif><cfif isDefined("Exception")><h2>Error:</h2><cfdump var="#Exception#" format="text"></cfif><cfif isDefined("request")><h2>Request:</h2><cfdump var="#request#" format="text"></cfif><cfif isDefined("error")><h2>Error:</h2><cfdump var="#error#" format="text"></cfif><cfif isDefined("url")><h2>URL:</h2><cfdump var="#url#" format="text"></cfif><cfif isDefined("form")><h2>Form:</h2><cfdump var="#form#" format="text"></cfif><cfif isDefined("cgi")><h2>CGI:</h2><cfdump var="#cgi#" format="text"></cfif><cfif isDefined("session")><h2>Session:</h2><cfdump var="#session#" format="text"></cfif><cfif isDefined("cookie")><h2>Cookie:</h2><cfdump var="#cookie#" format="text"></cfif></cfoutput>
</cfsavecontent>
<cfif request.isDeveloper>
	<cfoutput>#Evaluate("emailText")#</cfoutput>
	<cfelse>
	<cftry>
		<cfmail to="#error.mailTo#" type="html" from="csr@indiana.edu" subject="#application.applicationName# error">
			<cfoutput>#evaluate("emailText")#</cfoutput>
		</cfmail>
		<cfset formScope = "">
		<cfloop collection="#form#" item="key">
			<cfset formScope = listAppend(formScope, "#key#:#form[key]#", "|")>
		</cfloop>
		<cfquery datasource="#request.dsn#" name="recordError">
			INSERT INTO [track_error]
			([sID],[error],[message],[template],[line],[referer],[server],[path],[queryString],[section],[page],[form],[browser],[ipAddress],[created])
			VALUES
			(<cfif structKeyExists(request, "sID")>'#request.sID#'<cfelse>NULL</cfif>
			,<cfif isDefined("error") and structKeyExists(error, "diagnostics")>'#error.Diagnostics#'<cfelse>NULL</cfif>
			,<cfif isDefined("error") and structKeyExists(error, "message")>'#error.message#'<cfelse>NULL</cfif>
			,<cfif isDefined("error") and structKeyExists(error, "template")>'#error.template#'<cfelse>NULL</cfif>
			,<cfif isDefined("error") and structKeyExists(error, "tagcontext") and isArray(error.tagContext) and arraylen(error.tagContext) gte 1 and structKeyExists(error.tagContext[1], "line")>'#error.tagContext[1].line#'<cfelse>NULL</cfif>
			,'#cgi.HTTP_REFERER#'
			,'#cgi.HTTP_HOST#'
			,'#replace(removeChars(expandPath('.'),1,len(expandPath('/'))-1)&'\','\','/','ALL')#'
			,'#cgi.QUERY_STRING#'
			,<cfif structKeyExists(request, "section")>'#request.section#'<cfelse>NULL</cfif>
			,<cfif structKeyExists(request, "pageNumber")>'#request.pageNumber#'<cfelse>NULL</cfif>
			,'#formScope#'
			,'#cgi.HTTP_USER_AGENT#'
			,'#cgi.REMOTE_ADDR#'
			,getDate())
		</cfquery>
		<cfcatch type="any">
		</cfcatch>
	</cftry>
</cfif>
<cfinclude template="footer.cfm">
</cfprocessingdirective>
