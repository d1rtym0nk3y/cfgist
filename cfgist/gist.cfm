<cfif thistag.executionmode is "start"><cfsilent>
	<cfparam name="attributes.id" />
	<cfparam name="attributes.cachePath" default="" />
	<cfscript>
	cacheFile = attributes.cachePath & attributes.id & ".html";
	if(len(attributes.cachePath) && fileExists(cacheFile)) {
		html = fileRead(cacheFile);
		writeOutput(html);
		exit;
	}
	else {
		js = new http(url="https://gist.github.com/#attributes.id#.js").send().getPrefix().filecontent;
	}
	</cfscript>
	<cfsavecontent variable="javascriptCode">
	/* 
	*	gist's use document.write() which doesn't exists in the rhino context
	*	so we'll create a dummy that does what we want, - pass the string
	*	back to coldfusion
	*/
	document = {
		write: function(s) {
			var buffer = variables.get("buffer");
			buffer += s;
			variables.set("buffer", buffer);
		}
	}
	<cfoutput>#js#</cfoutput>
	</cfsavecontent>
	<cfscript>
	buffer = "";
	globalScope = java("org.mozilla.javascript.tools.shell.Global");
	scriptContext = java("org.mozilla.javascript.ContextFactory").getGlobal().enterContext(javacast("null", 0));
	globalScope.init(scriptContext);
	scriptContext.setOptimizationLevel(-1);
	scriptContext.initStandardObjects(globalScope);
	globalScope.putProperty(globalScope, "variables", variables );
	scriptContext.evaluateString(globalScope,variables.javascriptCode,"cf-rhino-script",0,javacast("null", 0));
	if(len(attributes.cachePath)) fileWrite(cacheFile, buffer);
	function java(class) {
		return createObject("java", class, getdirectoryFromPath(getCurrentTemplatePath()) & "/js.jar");
	}
	</cfscript>
</cfsilent>
<cfoutput>#buffer#</cfoutput>
</cfif>