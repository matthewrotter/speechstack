// The contents of this file will be executed before any of
// your view controllers are ever executed, including the index.
// You have access to all functionality on the `Alloy` namespace.
//
// This is a great place to do any initialization for your app
// or create any global variables/functions that you'd like to
// make available throughout your app. You can easily make things
// accessible globally by attaching them to the `Alloy.Globals`
// object. For example:
//
// Alloy.Globals.someGlobalFunction = function(){};

var log = function() { console.log.apply(console, ['console.log'].concat([].slice.apply(arguments))); };

var xhr = function xhr(endpoint, method, data, callback) {// could make method optional...
	method = method || 'POST';

    var xhr = Ti.Network.createHTTPClient();

    xhr.onload = function() {
        var response = JSON.parse(xhr.responseText);
        if (response.error) {
            alert("Error: " + _.pluck(respone.errors, 'message').join(', '));
            return;
        }
        callback(response);
    };

    xhr.onerror = function(e) {
        alert('Error: ' + e);
    };

    var url = endpoint;
    log('XHRing to ' + url);
    xhr.open(method, url);

    xhr.setRequestHeader('Content-Type', 'application/json; charset=utf-8');

    data = (typeof data !== 'string') ? JSON.stringify(data) : data;
    xhr.send(data);
};
Alloy.Globals.xhr = xhr;
