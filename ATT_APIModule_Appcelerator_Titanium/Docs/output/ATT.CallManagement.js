Ext.data.JsonP.ATT_CallManagement({"parentMixins":[],"statics":{"css_var":[],"event":[],"css_mixin":[],"method":[],"cfg":[],"property":[]},"html":"<div><pre class=\"hierarchy\"><h4>Files</h4><div class='dependency'><a href='source/attTitaniumAPI.html#ATT-CallManagement' target='_blank'>attTitaniumAPI.js</a></div></pre><div class='doc-contents'><p><b>Introduction</b></p>\n\n<p>The Call Management API exposes SMS and Voice Calling APIs, which enable app developers to create voice-enabled apps that send or receive calls, provide Interactive Voice Response (IVR) logic, Automatic Speech Recognition (ASR), Voice to Text (VTT), Text (SMS) integration, and more.</p>\n\n<p><b>Description</b></p>\n\n<p>The Call Management API provides app provisioning, or operations to support the creation of outgoing call sessions and sending of signals to existing sessions. Incoming calls sessions are created automatically in the call environment.</p>\n\n<p>If your application hosts a service that complies with an AT&amp;T specified callback, the application may also receive MMS messages. AT&amp;T will deliver MMS messages to the application as soon as they arrive on the AT&amp;T network.</p>\n\n<p><b>The Call Management API provides the following methods:</b></p>\n\n<p>• createSession</p>\n\n<p>• sendSignal</p>\n</div><div class='members'><div class='members-section'><div class='definedBy'>Defined By</div><h3 class='members-title icon-method'>Methods</h3><div class='subsection'><div id='method-createSession' class='member first-child not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='ATT.CallManagement'>ATT.CallManagement</span><br/><a href='source/attTitaniumAPI.html#ATT-CallManagement-method-createSession' target='_blank' class='view-source'>view source</a></div><a href='#!/api/ATT.CallManagement-method-createSession' class='name expandable'>createSession</a>( <span class='pre'>options, success, error</span> ) : Object</div><div class='description'><div class='short'>Creates a new outbound voice or SMS session. ...</div><div class='long'><p>Creates a new outbound voice or SMS session.</p>\n<h3 class=\"pa\">Parameters</h3><ul><li><span class='pre'>options</span> : Object<div class='sub-desc'><p>A JSON object containing the following properties:</p>\n<ul><li><span class='pre'>body</span> : Object<div class='sub-desc'><p>An object containing all of the parameters that a user needs for call management. Valid parameters are:</p>\n<ul><li><span class='pre'>numberToDial</span> : String<div class='sub-desc'><p>The MSISDN of the recipient(s).For multiple addresses, the value of this parameter will be an array of string.</p>\n</div></li><li><span class='pre'>feature</span> : String<div class='sub-desc'><p>The type of feature for Call Management.</p>\n</div></li><li><span class='pre'>messageText</span> : String<div class='sub-desc'><p>The text of the message to send.</p>\n</div></li></ul></div></li><li><span class='pre'>contentType</span> : String<div class='sub-desc'><p>Specifies the format of the message content. Valid values are:</p>\n\n<p>• application/json</p>\n\n<p>• application/xml</p>\n\n<p>• application/x-www-form-urlencoded</p>\n</div></li><li><span class='pre'>accept</span> : String (optional)<div class='sub-desc'><p>Specifies the format of the body of the response. Valid values are:</p>\n\n<p>• application/json</p>\n\n<p>• application/xml\nThe default value is: application/json</p>\n</div></li></ul></div></li><li><span class='pre'>success</span> : Function<div class='sub-desc'><p>The callback function that is called when the method returns success.</p>\n</div></li><li><span class='pre'>error</span> : Function<div class='sub-desc'><p>The callback function that is called when the method returns an error.</p>\n</div></li></ul><h3 class='pa'>Returns</h3><ul><li><span class='pre'>Object</span><div class='sub-desc'><p>An object containing the response. The format of the response (JSON or XML) is specified by the value of the accept parameter in the request. This response object contains the Call Management ID that is used in the ID property of the options parameter in the sendSignal method.</p>\n\n<p><strong>Examples:</strong></p>\n\n<p><b>Example 1: </b> The following example of the createSession method uses a contentType of 'application/json'.</p>\n\n<pre><code> createSession({\n             \"body\":{ \"numberToDial\" : \"xxxxxxxxxx,xxxxxxxxxx\", \"Subject\" : \"Test Broadcast Message\", \"feature\" : \"broadcastMsg\" },\n             \"contentType\" : \"application/json\",\n             \"accept\" : \"application/json\"\n },  function(data) {\n\n      success Callback\n\n  }, function(error) {\n\n      error Callback\n\n  });\n</code></pre>\n\n<p><i>Note: xxxxxxxxxx represents valid wireless number.</i></p>\n\n<p><b>Example 2.</b> The following example of the createSession method uses a contentType of 'application/xml'.</p>\n\n<pre><code> createSession({\n             \"body\":{ \"numberToDial\" : \"xxxxxxxxxx,xxxxxxxxxx\", \"Subject\" : \"Test Broadcast Message\", \"feature\" : \"broadcastMsg\" },\n             \"contentType\" : \"application/xml\",\n             \"accept\" : \"application/json\"\n  },  function(data) {\n\n      success Callback\n\n  }, function(error) {\n\n      error Callback\n\n  });\n</code></pre>\n\n<p><i>Note: xxxxxxxxxx represents valid wireless number.</i></p>\n\n<p><b>Example 3.</b> The following example of the createSession method uses a contentType of 'application/x-www-form-urlencoded'.</p>\n\n<pre><code> createSession({\n             \"body\":\"numberToDial=xxxxxxxxxx&amp;Subject=broadcastMsg&amp;Subject=Test%20Broadcast\",\n             \"contentType\" : \"application/x-www-form-urlencoded\",\n             \"accept\" : \"application/json\"\n },  function(data) {\n\n     success Callback\n\n }, function(error) {\n\n     error Callback\n\n });\n</code></pre>\n\n<p><i>Note: xxxxxxxxxx represents valid wireless number.</i></p>\n</div></li></ul></div></div></div><div id='method-sendSignal' class='member  not-inherited'><a href='#' class='side expandable'><span>&nbsp;</span></a><div class='title'><div class='meta'><span class='defined-in' rel='ATT.CallManagement'>ATT.CallManagement</span><br/><a href='source/attTitaniumAPI.html#ATT-CallManagement-method-sendSignal' target='_blank' class='view-source'>view source</a></div><a href='#!/api/ATT.CallManagement-method-sendSignal' class='name expandable'>sendSignal</a>( <span class='pre'>options, success, error</span> ) : Object</div><div class='description'><div class='short'>sends a signal to voice or SMS session. ...</div><div class='long'><p>sends a signal to voice or SMS session.</p>\n<h3 class=\"pa\">Parameters</h3><ul><li><span class='pre'>options</span> : Object<div class='sub-desc'><p>A JSON object containing the following properties:</p>\n<ul><li><span class='pre'>cmsId</span> : String<div class='sub-desc'><p>Specifies the session ID that is returned by the createSession method.</p>\n</div></li><li><span class='pre'>body</span> : Object<div class='sub-desc'><p>An object containing all of the parameters that a user needs to send signal. Valid parameters are:</p>\n<ul><li><span class='pre'>signal</span> : String<div class='sub-desc'><p>The type of signal that needs to send.</p>\n</div></li></ul></div></li><li><span class='pre'>contentType</span> : String<div class='sub-desc'><p>Specifies the format of the message content. Valid values are:</p>\n\n<p>• application/json</p>\n\n<p>• application/xml</p>\n\n<p>• application/x-www-form-urlencoded</p>\n</div></li><li><span class='pre'>accept</span> : String (optional)<div class='sub-desc'><p>Specifies the format of the body of the response. Valid values are:</p>\n\n<p>• application/json</p>\n\n<p>• application/xml\nThe default value is: application/json</p>\n</div></li></ul></div></li><li><span class='pre'>success</span> : Function<div class='sub-desc'><p>The callback function that is called when the method returns success.</p>\n</div></li><li><span class='pre'>error</span> : Function<div class='sub-desc'><p>The callback function that is called when the method returns an error.</p>\n</div></li></ul><h3 class='pa'>Returns</h3><ul><li><span class='pre'>Object</span><div class='sub-desc'><p>An object containing the response. The format of the response (JSON or XML) is specified by the value of the accept parameter in the request. This response object contains the Call Management ID that is used in the id property of the options parameter in the sendSignal method.</p>\n\n<p><strong>Example 1.</strong></p>\n\n<p>The following example of the sendSignal method uses a contentType of 'application/json'.</p>\n\n<pre><code> sendSignal({\n             \"body\":{ \"signal\" : \"exit\" },\n             \"contentType\" : \"application/json\",\n             \"accept\" : \"application/json\"\n  },  function(data) {\n\n       success Callback\n\n  }, function(error) {\n\n       error Callback\n\n  });\n</code></pre>\n\n<p><b>Example 2.</b> The following example of the sendSignal method uses a contentType of 'application/xml'.</p>\n\n<pre><code> sendSignal({\n             \"body\":{ \"signal\" : \"exit\" },\n             \"contentType\" : \"application/xml\",\n             \"accept\" : \"application/json\"\n  },  function(data) {\n\n      success Callback\n\n  }, function(error) {\n\n      error Callback\n\n  });\n</code></pre>\n\n<p><b>Example 3.</b> The following example of the sendSignal method uses a contentType of 'application/x-www-form-urlencoded'.</p>\n\n<pre><code> sendSignal({\n             \"body\":\"signal=exit\",\n             \"contentType\" : \"application/x-www-form-urlencoded\",\n             \"accept\" : \"application/json\"\n },  function(data) {\n\n     success Callback\n\n }, function(error) {\n\n     error Callback\n\n });\n</code></pre>\n</div></li></ul></div></div></div></div></div></div></div>","tagname":"class","inheritable":null,"singleton":false,"override":null,"html_meta":{},"mixins":[],"files":[{"href":"attTitaniumAPI.html#ATT-CallManagement","filename":"attTitaniumAPI.js"}],"linenr":1358,"members":{"css_var":[],"event":[],"css_mixin":[],"method":[{"tagname":"method","owner":"ATT.CallManagement","name":"createSession","id":"method-createSession","meta":{}},{"tagname":"method","owner":"ATT.CallManagement","name":"sendSignal","id":"method-sendSignal","meta":{}}],"cfg":[],"property":[]},"alternateClassNames":[],"aliases":{},"inheritdoc":null,"component":false,"private":null,"subclasses":[],"name":"ATT.CallManagement","extends":null,"uses":[],"mixedInto":[],"superclasses":[],"id":"class-ATT.CallManagement","enum":null,"meta":{},"requires":[]});