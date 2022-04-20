component name="bent_dialect" output="true"
{
    /**********************************************
        Application.cfc Settings: The Settings below allow you to override global ColdFusion settings to keep configurations local to your application. This ensures you can make quick adjustments to your application configuration. Ensure you review the settings below and replace dummy information and remove settings that are not applicable to your coldfusion application.
    http://help.adobe.com/en_US/ColdFusion/9.0/CFMLRef/WSc3ff6d0ea77859461172e0811cbec22c24-750b.html
    **********************************************/

    this.name                           = "bent_dialect_2108802A_E2B4_C9AF_CB2E9A7C6562973D";
    this.applicationTimeout             = createTimeSpan(1, 0, 0, 0);       
    this.clientManagement               = false;
    this.loginStorage                   = "cookie";
    this.sessionManagement              = true;
    this.sessionTimeout                 = createTimeSpan(0, 12, 0, 0);
    this.setClientCookies               = true;
    this.timeout                        = 30;
    this.debugipaddress                 = "";
    this.enablerobustexception          = false;
   
    /*********************************************
        Application.cfc Event Callbacks: These functions are default callbacks that are invoked during regular coldfusion activity. For instance, when your application first starts up, the OnApplicationStart() method will be invoked allowing you to handle custom logic on first application startup. Ensure you review these methods to see which may be applicable to your application. It is recommended that at least the OnRequestStart() method is always defined.
    http://livedocs.adobe.com/coldfusion/8/htmldocs/help.html?content=AppEvents_01.html
    **********************************************/
    
    public boolean function OnApplicationStart(){
        //Handle OnApplicationStart Callback

        application.dsn = "web2";
        application.server = "PROD";

        // ------------------------------------------------------------------
        // paths
        application.path = "/bent_dialect";
        application.url = "https://survey.indiana.edu" & application.path;
        application.root = application.path;
        request.isDeveloper = true;


        if (application.server eq "dev"){
            application.root = application.path;
            application.url = "https://dev.survey.indiana.edu/" & application.path;
        }
        if (application.server eq "qa"){
            application.url = "https://qa.survey.indiana.edu" & application.path;
        }
        if (application.server eq "stage"){
            application.url = "https://stage.survey.indiana.edu" & application.path;
        }
        if (application.server eq "prod"){
            application.url = "https://survey.indiana.edu" & application.path;
        }

        // ------------------------------------------------------------------

        return true;
    }
    public void function OnApplicationEnd(struct ApplicationScope=structNew()){
        //Handle OnApplicationEnd Callback
    }
    public void function OnRequest(required string TargetPage){
        //Handle OnRequest Callback
    }
    public boolean function OnRequestStart(required string TargetPage){
        //Handle OnRequestStart Callback

        //halt
        include "maintenance.cfm";
        if (structKeyExistS(url, "halt") and url.halt eq "stop"){
            applicationStop();
            abort;
        }

        request.url = application.url;
        request.title = "";
        request.root = application.root;
        request.isDeveloper = true;
        request.queryString = "";
        request.id = "";
        request.page = "";
        if (structKeyExists(url, "id")) request.id = url.id;
        if (structKeyExists(form, "id")) request.id = form.id;
        if (structKeyExists(url, "page")) request.page = url.page;
        if (structKeyExists(form, "page")) request.page = form.page;
        request.qs = qs;

        include arguments.TargetPage;                           

        return true;
    }
    public void function OnRequestEnd(){
        //Handle OnRequestEnd Callback
    }
    public void function OnCFCRequest(string cfc, string method, struct args){
        //Handle OnCFCRequest Callback
    }
    public void function OnSessionStart(){
        //Handle OnSessionStart Callback
    }
    public void function OnSessionEnd(required struct SessionScope, struct ApplicationScope=structNew()){
        //Handle OnSessionEnd Callback
    }
    public void function OnError(required any Exception, required string EventName){
        /*Handle OnError Callback
            Not all errors are caused by CodeFusion. You many wish to enable detail errors as well.
            https://solutions.hostmysite.com/index.php?/Knowledgebase/Article/View/8598/0/enable-detailed-errors
            Uncomment the line below to display errors */
        request.title = "";
        request.root = application.root;
        include "error.cfm";
    }
    public boolean function OnMissingTemplate(required string TargetPage){
        writeDump(TargetPage);
        //Handle OnMissingTemplate Callback
        return true;
    }

    function qs() {
        request.queryString = reReplace(request.queryString, "^&+", "");
        if (structKeyExists(request, "id") and not findNoCase("id=", request.queryString)){
            request.queryString = listAppend(request.queryString, "id=#request.id#", "&");
        } 
        if (request.queryString eq "") return "";
        if (left(request.queryString, 1) neq "?" ) return "?" & request.queryString;
        return request.queryString;
    }

    function halt(){
        if (left(cgi.remote_addr,10) eq "129.79.219"){
            applicationStop();
        }
    }

    function debug(message, toAbort="false"){
        if (not request.debugMode) return;

        try {
            var _temp = callStackGet();
            writeOutput('<div class="debug">' & replaceNoCase(_temp[2].template,application.templateRoot,'') & ' (' & _temp[2].lineNumber & '): ');
            if (isStruct(message)) writeDump(message);
            else if (isArray(message)) writeDump(message);
            else if (isObject(message)) writeDump(message);
            else if (isPDFObject(message)) writeDump(message);
            else if (isQuery(message)) writeDump(message);
            else if (isXMLDoc(message)) writeDump(message);
            else if (isXML(message)) writeDump(message);
            else if (isCustomFunction(message)) writeDump(message);
            else if (isImage(message)) writeDump(message);
            else if (isDate(message)) writeOutput(dateFormat(message, "mm/dd/yyyy") & " " & timeFormat(message, "hh:mm:ss tt"));
            else writeOutput(message);
            writeOutput('</div>');
        } catch (Exception e){
            writeOutput('<div class="debug">');
            writeDump(message);
            writeOutput('</div>');
        }

        if (toAbort) abort;
    }

    function timer(message = ""){
        if (not request.debugMode) return;

        try {
            _temp = callStackGet();
            writeOutput('<div class="debug timer">' & replaceNoCase(_temp[2].template,application.templateRoot,'') & ' (' & _temp[2].lineNumber & '): ');
            currentTicks = getTickCount() - request.timer_start;
            writeOutput('#currentTicks/1000# seconds, #currentTicks# ms (#getTickCount()# ticks)');
            if (message neq "") writeOutput(': ' & message);
            writeOutput('</div>');
        } catch (Exception e){
            writeOutput('<div class="debug timre">');
            writeDump(getTickCount());
            writeOutput('</div>');
        }

    }
        
}