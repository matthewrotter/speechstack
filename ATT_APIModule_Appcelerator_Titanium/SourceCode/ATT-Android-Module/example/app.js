// This is a test harness for module

// open a single window
var win = Ti.UI.createWindow({
	backgroundColor : 'white'
});
var label = Ti.UI.createLabel();
win.add(label);
win.open();

//Require module here
var attplugins = require('ti.api.att');
Ti.API.info("module is => " + attplugins);

var args1 = {

	// "address" : "<Address>tel:6503916200</Address>",
	// "subject" : "<Subject>test</Subject>",
	// "priority" : "<Priority>High</Priority>",
//	"address" : "tel:6505765067",
//	"subject" : "testMMS",
//	"priority" : "High",
	//"body":{ "Address" : "tel:6504549816,tel:6503916200", "Subject" : "image file", "Priority" : "High" },
	//"body":"<MmsRequest>"+"\n"+"<Address>tel:+13500000992</Address>"+"\n"+"<Subject>test</Subject>"+"\n"+"<Priority>High</Priority>"+"\n"+"</MmsRequest>",
	"body":"Address=tel%3A%2B13500000991&Priority=High&Subject=image%20file",
	"contentType" : "application/x-www-form-urlencoded",
	//"contentType" : "application/xml",
	"accept" : "application/json",
	"accessToken" : "Bearer 6115d8c6ad2e332bc70a95d00ed297bd",
	"url" : "https://api.att.com/rest/mms/2/messaging/outbox",
	"attachments":[{}]
//	"attachments" : [ {
//		"fileName" : "KS_nav_views.png",
//		"fileType" : "image/png",
//		"filePath" : "/mnt/sdcard/KS_nav_views.png"
//	}, {
//		"fileName" : "KS_nav_views.png",
//		"fileType" : "image/png",
//		"filePath" : "/mnt/sdcard/KS_nav_views.png"
//	} ]
}

var args2 = {
	// "recipentPhoneNumber" : "<Address>tel:6503916200</Address>",
	// "messageSubject" : "<Subject>test</Subject>",
	// "messagePriority" : "<Priority>High</Priority>",
	"address" : "tel:6503916200,test@att.com",
	"subject" : "testMMS",
	"text" : "hello everyone 1st",
	//"body":{ "Addresses": ["test@att.com","tel:6503916200"], "Text": "Hello world", "Subject": "Hello" },
	"body":"<MessageRequest>"+"\n"+"<Addresses>tel:2087654321,tel:2023456789,test@att.com</Addresses>"+"\n"+"<Subject>Hi</Subject>"+"\n"+"</MessageRequest>",
	//"body":"Addresses=tel%3A%2B2087654321&Addresses=tel%3A%2B2023456789&Addresses=test@att.com&Text=Hello&Subject=Hi",
	//"contentType" : "application/x-www-form-urlencoded",
	"contentType" : "application/xml",
	"accept" : "application/json",
	"accessToken" : "Bearer 3c4a2583ea3abd176627fdadb669a9ba",
	"url" : "https://api.att.com/rest/1/MyMessages",
	//attachments : [{}]
	"attachments" : [ {
		"fileName" : "KS_nav_views.png",
		"fileType" : "image/png",
		"filePath" : "/mnt/sdcard/KS_nav_views.png"
	}, {
		"fileName" : "KS_nav_views.png",
		"fileType" : "image/png",
		"filePath" : "/mnt/sdcard/KS_nav_views.png"
	} ]
};

//attplugins.sendMMS(args1, function(data) {
//
//	alert("MMSsuccess is " + data + JSON.stringify(data));
//	Ti.API.info("MMSsuccess is " + data);
//}, function(error) {
//	var y = JSON.stringify(error);
//	alert("MMSerror is " + error + y);
//});
// attplugins.sendMessage(args2, function(data) {
// alert("MOBOsuccess is " + data + JSON.stringify(data));
// Ti.API.info("MOBOsuccess is " + data);
// }, function(error) {
// var y = JSON.stringify(error);
// alert("MOBOerror is " + error + y);
// });

var args3 = {
	"filePath" : "/mnt/sdcard/earcon_listening.wav",
	"host" : "https://api.att.com/rest/1/SpeechToText",
	"token" : "Bearer 73febe5e86bb1fe0477342cabc510ce9",
	"headerContentType" : "audio/wav",
	"headerXSpeechContent" : "BusinessSearch",

	"headerAccept" : "application/json"
};
	attplugins.speechToText(args3, function(data) {
		alert("success is " + data + JSON.stringify(data));
		Ti.API.info("success is " + data);
	}, function(error) {
		var y = JSON.stringify(error);
		alert("error is " + error + y);
	});

