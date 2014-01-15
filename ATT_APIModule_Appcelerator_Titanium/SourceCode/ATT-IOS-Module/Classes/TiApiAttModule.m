/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiApiAttModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiBlob.h"
#import "NSData+Base64.h"

#define    REQUESTMETHOD                @"POST"
#define    CONTENTTYPEJSON              @"application/json"
#define    CONTENTTYPEXML               @"application/xml"
#define    CONTENTTYPEURLENCODED        @"application/x-www-form-urlencoded"

#define    KEYTOKEN                     @"accessToken"
#define    KEYURL                       @"url"
#define    KEYADDRESS                   @"address"
#define    KEYADDRESSMOBO               @"addresses"
#define    KEYSUBJECT                   @"subject"
#define    KEYPRIORITY                  @"priority"
#define    KEYTEXT                      @"text"
#define    KEYATTACHMENT                @"attachments"
#define    KEYFILENAME                  @"fileName"
#define    KEYFILETYPE                  @"fileType"
#define    KEYFILEPATH                  @"filePath"
#define    KEYACCEPTTYPE                @"accept"
#define    KEYCONTENTTYPE               @"contentType"
#define    KEYFILEOBJECT                @"fileObject"
#define    KEYMESSAGEBODY               @"body"

#define   _ReleaseObj(obj)           if(obj != nil) \
[obj release];\
obj = nil;

#define   _setRequiredParamAndCheckFailure(dict,key,paramVar,faliuremessage)           if((paramVar = [dict objectForKey:key]) == nil\
|| [paramVar length] == 0){\
[self sendErrorMessage:faliuremessage];\
return;                         \
}
#define   _setOptionalParam(dict,key,paramVar)             { if((paramVar = [dict objectForKey:key]) == nil ) \
paramVar = @""; }
#define   _optinalValueForKey(dict,key,paramVar)           ((paramVar = [dict objectForKey:key]) == nil ? @"" : paramVar)

#define      BODYHASTOBECREATED

typedef enum
{
    CONTENTJSON,
    CONTENTXML,
    CONTENTURLENCODED
}ContentType;

@interface TiApiAttModule (PrivateMethod)
- (void) sendErrorMessage:(const NSString*)message;
- (void) releaseCallback;

- (BOOL)jsonRepresentationOfDic:(NSDictionary*)fragment into:(NSMutableString*)json;
- (BOOL)appendValue:(id)fragment into:(NSMutableString*)json;
- (BOOL)appendString:(NSString*)fragment into:(NSMutableString*)json;
- (void)initializeCharSet;
- (BOOL)humanReadable;
@end

@implementation TiApiAttModule

static const NSString*  requestBoundry = @"---------------------------14737809831466499882746641449";
static const NSString*  errorMessage   = @"Error while executing request";

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"1438e49f-bb23-4d22-af91-30bba9e0ac69";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.api.att";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
    [self initializeCharSet];
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

- (void) setDebug:(id)debug
{
    is_debug = [TiUtils boolValue:debug];
}
#pragma mark Cleanup 

- (void) releaseCallback
{
    RELEASE_TO_NIL(errorCallback);
    RELEASE_TO_NIL(successCallback);
    RELEASE_TO_NIL(errorMoBoCallback);
    RELEASE_TO_NIL(successMoBoCallback);
}

-(void)dealloc
{
	// release any resources that have been retained by the module
    // release any resources that have been retained by the module
    [self releaseCallback];
    RELEASE_TO_NIL(mms_response);
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

-(BOOL)humanReadable{
    return false;
}

static NSMutableCharacterSet *kEscapeChars;

-(void)initializeCharSet {
	kEscapeChars = [[NSMutableCharacterSet characterSetWithRange: NSMakeRange(0,32)] retain];
	[kEscapeChars addCharactersInString: @"\"\\"];
}


- (BOOL)appendString:(NSString*)fragment into:(NSMutableString*)json {
    
    [json appendString:@"\""];
    
    NSRange esc = [fragment rangeOfCharacterFromSet:kEscapeChars];
    if ( !esc.length ) {
        // No special chars -- can just add the raw string:
        [json appendString:fragment];
        
    } else {
        NSUInteger length = [fragment length];
        for (NSUInteger i = 0; i < length; i++) {
            unichar uc = [fragment characterAtIndex:i];
            switch (uc) {
                case '"':   [json appendString:@"\\\""];       break;
                case '\\':  [json appendString:@"\\\\"];       break;
                case '\t':  [json appendString:@"\\t"];        break;
                case '\n':  [json appendString:@"\\n"];        break;
                case '\r':  [json appendString:@"\\r"];        break;
                case '\b':  [json appendString:@"\\b"];        break;
                case '\f':  [json appendString:@"\\f"];        break;
                default:
                    if (uc < 0x20) {
                        [json appendFormat:@"\\u%04x", uc];
                    } else {
                        CFStringAppendCharacters((CFMutableStringRef)json, &uc, 1);
                    }
                    break;
                    
            }
        }
    }
    
    [json appendString:@"\""];
    //NSLog(@"###############*****## append string ############ %@",json);
    return YES;
}

- (BOOL)appendValue:(id)fragment into:(NSMutableString*)json {
    if ([fragment isKindOfClass:[NSDictionary class]]) {
        if (![self jsonRepresentationOfDic:fragment into:json])
            return NO;
        
    } else if ([fragment isKindOfClass:[NSArray class]]) {
        if (![self appendArray:fragment into:json])
            return NO;
        
    } else if ([fragment isKindOfClass:[NSString class]]) {
        if (![self appendString:fragment into:json])
            return NO;
        
    } else if ([fragment isKindOfClass:[NSNumber class]]) {
        if ('c' == *[fragment objCType])
            [json appendString:[fragment boolValue] ? @"true" : @"false"];
        else
            [json appendString:[fragment stringValue]];
        
    } else if ([fragment isKindOfClass:[NSNull class]]) {
        [json appendString:@"null"];
    } else {
        return NO;
    }
    return YES;
}

- (BOOL)appendArray:(NSArray*)fragment into:(NSMutableString*)json {
    [json appendString:@"["];
    
    BOOL addComma = NO;
    for (id value in fragment) {
        if (addComma)
            [json appendString:@","];
        else
            addComma = YES;
        
        if (![self appendValue:value into:json]) {
            return NO;
        }
    }
    [json appendString:@"]"];
    return YES;
}



-(BOOL)jsonRepresentationOfDic:(NSDictionary*)fragment into:(NSMutableString*)json{
    
    [json appendString:@"{"];
    
    NSString *colon = @":";
    BOOL addComma = NO;
    NSArray *keys = [fragment allKeys];
    
    for (id value in keys) {
        if (addComma)
            [json appendString:@","];
        else
            addComma = YES;
        
        if (![self appendString:value into:json])
            return NO;
        
        [json appendString:colon];
        //NSLog(@"###############*****######in function fragment and json########= %@ and json= %@",fragment,json);
        if (![self appendValue:[fragment objectForKey:value] into:json]) {
            //[self addErrorWithCode:EUNSUPPORTED description:[NSString stringWithFormat:@"Unsupported value for key %@ in object", value]];
            //NSLog(@"###############*****############## NO");
            return NO;
        }
    }
    [json appendString:@"}"];
    //NSLog(@"###############*****## final ############ %@",json);
    return YES;
}

#pragma mark - 
#pragma Public APIs

#pragma mark SENDMMS
-(void)sendMMS:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    
    if (successCallback) {
        RELEASE_TO_NIL(successCallback);
    }
    if (errorCallback) {
        RELEASE_TO_NIL(errorCallback);
    }
    successCallback = [[args objectAtIndex:1] retain];
    errorCallback = [[args objectAtIndex:2] retain];
    
    
    
    //.................Intiliaze Local variables......................./
    const NSDictionary* mmsRequestparameter = [args objectAtIndex:0];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableData *body = [NSMutableData data];
    NSString *contentTypeHeader = nil;
    NSString *paramValue= nil;
    id subject = [NSMutableString stringWithString:@""];
    NSString*        contentType = nil;
    NSUInteger       contentValue;
    ///.....................................///
    
    //.................Procedure......................./
    //Set Header of request
    [request setHTTPMethod:REQUESTMETHOD];
    _setRequiredParamAndCheckFailure(mmsRequestparameter,KEYURL,paramValue,errorMessage);
    [request setURL:[NSURL URLWithString:paramValue]];
    _setRequiredParamAndCheckFailure(mmsRequestparameter,KEYTOKEN,paramValue,errorMessage);
    [request setValue:paramValue forHTTPHeaderField:@"Authorization"];
    _setOptionalParam(mmsRequestparameter,KEYACCEPTTYPE,paramValue);
    [request setValue:paramValue forHTTPHeaderField:@"Accept"];
    acceptType = ([paramValue isEqualToString:CONTENTTYPEXML] == TRUE) ? CONTENTXML : CONTENTJSON;
    
    //.. check and set content type
    _setOptionalParam(mmsRequestparameter,KEYCONTENTTYPE,contentType);
    (([contentType isEqualToString:CONTENTTYPEXML] == TRUE) ? (contentValue = CONTENTXML) : ([contentType isEqualToString:CONTENTTYPEURLENCODED] == TRUE) ? 
     (contentValue = CONTENTURLENCODED) : (contentValue = CONTENTJSON));
    contentTypeHeader =  [NSString stringWithFormat:@"multipart/form-data; type=\"%@\"; start=\"<startpart>\"; boundary=\"%@\"",contentType,requestBoundry];
    [request addValue:contentTypeHeader forHTTPHeaderField: @"Content-Type"];
    
    //Set body of request set recipent address
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",requestBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type:%@\r\n",contentType] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-ID:<startpart>\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"root-fields\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
   
#ifdef BODYHASTOBECREATED
    id messageBody= [mmsRequestparameter objectForKey:KEYMESSAGEBODY];
    if(messageBody != nil)
    {
        switch (contentValue)
        {
            case CONTENTJSON:
            {
                [self jsonRepresentationOfDic:(NSDictionary*)messageBody into:subject];
                //NSLog(@"############################# %@",subject);
                //subject = [messageBody JSONRepresentation];
                break;
            }
            case CONTENTXML:
            case CONTENTURLENCODED:
            {
                subject = (NSString*)messageBody;
                break;
            }
        }
        
        [body appendData:[subject dataUsingEncoding:NSUTF8StringEncoding]];
    }
#else 
    _setRequiredParamAndCheckFailure(mmsRequestparameter,KEYMESSAGEBODY,subject,errorMessage);
    [body appendData:[subject dataUsingEncoding:NSUTF8StringEncoding]];
#endif
    
    //.... set attachment for the message
    NSArray* attachments = [mmsRequestparameter objectForKey:KEYATTACHMENT];
    if (attachments != nil && [attachments count] > 0) {
        //NSLog(@"######################### should not be here");
    for (NSDictionary* fileInfo in attachments)
    {
        if([[fileInfo allKeys] count] == 0)
        {
            [self sendErrorMessage:errorMessage];
            _ReleaseObj(request);
            return;
        }
        id attachmentBase64String = [fileInfo objectForKey:KEYFILEOBJECT]?[fileInfo objectForKey:KEYFILEOBJECT]:nil;
        NSData   *attachmentData = nil;
        NSString *attachmentfilename = [fileInfo objectForKey:KEYFILENAME];
        NSString *attachmentMimeType = [fileInfo objectForKey:KEYFILETYPE];
        if(attachmentBase64String == nil || [attachmentBase64String length] == 0)
        {
            //NSLog(@"##################################### Should not be here");
            NSString *attachmentPath = [fileInfo objectForKey:KEYFILEPATH];
            NSString *filePath = [[NSBundle mainBundle] pathForResource:attachmentfilename ofType:[attachmentPath pathExtension]];
            if(filePath == nil)
                filePath = attachmentPath;
            attachmentData = [[NSData alloc] initWithContentsOfFile:filePath];
            attachmentBase64String = [attachmentData base64EncodedString];
        }
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",requestBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        // where profile_photo is the key value or parameter value on server. must be confirm
        [body appendData:[[NSString stringWithFormat:@"Content-Type:%@\r\n",attachmentMimeType]dataUsingEncoding:NSUTF8StringEncoding ]];
        [body appendData:[[NSString stringWithFormat:@"Content-ID:<%@>\r\n",attachmentfilename] dataUsingEncoding:NSUTF8StringEncoding ]];
        [body appendData:[[NSString stringWithFormat:@"Content-Transfer-Encoding:base64\r\n"] dataUsingEncoding:NSUTF8StringEncoding ]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition:attachment; name=\"%@\"\r\n\r\n",attachmentfilename] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([attachmentBase64String isKindOfClass:([TiBlob class])]) {
            [body appendData:[[[attachmentBase64String data] base64EncodedString] dataUsingEncoding:NSUTF8StringEncoding]];
        }else{
            [body appendData:[attachmentBase64String dataUsingEncoding:NSUTF8StringEncoding]];
        }
        _ReleaseObj(attachmentData);
        
    }
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",requestBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    }
    
    if(is_debug)
    {
        NSLog(@"[INFO]MMS All Header Set::%@",[request allHTTPHeaderFields]);
        NSLog(@"[INFO]MMS Body ::%@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    }
    //Send request and handle response
    MessageHTTPRequest* httpRequest = [[MessageHTTPRequest alloc] initRequest:request withDelegate:self];
    [httpRequest autorelease];
    _ReleaseObj(request);
}



#pragma mark-
#pragma mark send MOBO Message

- (void)sendMessage:(id)args
{
    
    ENSURE_UI_THREAD_1_ARG(args);
    
    if (successMoBoCallback) {
        RELEASE_TO_NIL(successMoBoCallback);
    }
    if (errorMoBoCallback) {
        RELEASE_TO_NIL(errorMoBoCallback);
    }
    successMoBoCallback = [[args objectAtIndex:1] retain];
    errorMoBoCallback = [[args objectAtIndex:2] retain];
    
    
    //.................Intiliaze Local variables......................./
    const NSDictionary* mmsRequestparameter = [args objectAtIndex:0];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableData *body = [NSMutableData data];
    NSString *contentTypeHeader = nil;
    NSString *paramValue= nil;
    id mmsParameters = [NSMutableString stringWithString:@""];
    NSString*        contentType = nil;
    NSUInteger       contentValue;
    ///.....................................///
    
    //.................Procedure......................./
    //Set Header of request
    [request setHTTPMethod:REQUESTMETHOD];
    _setRequiredParamAndCheckFailure(mmsRequestparameter,KEYURL,paramValue,errorMessage);
    [request setURL:[NSURL URLWithString:paramValue]];
    _setRequiredParamAndCheckFailure(mmsRequestparameter,KEYTOKEN,paramValue,errorMessage);
    [request setValue:paramValue forHTTPHeaderField:@"Authorization"];
    _setOptionalParam(mmsRequestparameter,KEYACCEPTTYPE,paramValue);
    [request setValue:paramValue forHTTPHeaderField:@"Accept"];
    acceptType = ([paramValue isEqualToString:CONTENTTYPEXML] == TRUE) ? CONTENTXML : CONTENTJSON;
    
    //Set body of request set recipent addres
    _setOptionalParam(mmsRequestparameter,KEYCONTENTTYPE,contentType);
    (([contentType isEqualToString:CONTENTTYPEXML] == TRUE) ? (contentValue = CONTENTXML) : ([contentType isEqualToString:CONTENTTYPEURLENCODED] == TRUE) ? 
     (contentValue = CONTENTURLENCODED) : (contentValue = CONTENTJSON));
    contentTypeHeader = [NSString stringWithFormat:@"multipart/form-data; type=\"%@\"; start=\"<startpart>\"; boundary=\"%@\"",contentType,requestBoundry];
    [request setValue:contentTypeHeader forHTTPHeaderField:@"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",requestBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@; charset=UTF-8\r\n",contentType] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data; name=\"root-fields\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-ID:<startpart>\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
#ifdef BODYHASTOBECREATED    
    id messageBody= [mmsRequestparameter objectForKey:KEYMESSAGEBODY];
    if(messageBody != nil)
    {
        switch (contentValue)
        {
            case CONTENTJSON:
            {
                //NSLog(@"###############*****############## %@",messageBody);
                [self jsonRepresentationOfDic:(NSDictionary*)messageBody into:mmsParameters];
                //NSLog(@"##############null############### %@",mmsParameters);
                //mmsParameters = [messageBody JSONRepresentation];
                break;
            }
            case CONTENTXML:
            case CONTENTURLENCODED:
            {
                mmsParameters = (NSString*)messageBody;
                break;
            }
        }
        [body appendData:[[NSString stringWithFormat:@"%@\r\n",mmsParameters] dataUsingEncoding:NSUTF8StringEncoding]];
    }

#else 
    _setRequiredParamAndCheckFailure(mmsRequestparameter,KEYMESSAGEBODY,mmsParameters,errorMessage);
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",mmsParameters] dataUsingEncoding:NSUTF8StringEncoding]];
#endif
    //.... set attachment for the message
    NSArray* attachments = [mmsRequestparameter objectForKey:KEYATTACHMENT];
    if (attachments != nil && [attachments count] > 0) {
        for (NSDictionary* fileInfo in attachments)
        {
            if([[fileInfo allKeys] count] == 0)
            {
                continue;
            }
            id attachmentBase64String = [fileInfo objectForKey:KEYFILEOBJECT];
            NSData   *attachmentData = nil;
            NSString *attachmentfilename = [fileInfo objectForKey:KEYFILENAME];
            NSString *attachmentMimeType = [fileInfo objectForKey:KEYFILETYPE];
            if(attachmentBase64String == nil || [attachmentBase64String length] == 0)
            {
                NSString *attachmentPath = [fileInfo objectForKey:KEYFILEPATH];
                NSString *filePath = [[NSBundle mainBundle] pathForResource:attachmentfilename ofType:[attachmentPath pathExtension]];
                if(filePath == nil)
                    filePath = attachmentPath;
                attachmentData = [[NSData alloc] initWithContentsOfFile:filePath];
                attachmentBase64String = [attachmentData base64EncodedString];
            }
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",requestBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
            // where profile_photo is the key value or parameter value on server. must be confirm
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",attachmentfilename,attachmentfilename] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Type:%@\r\n",attachmentMimeType]dataUsingEncoding:NSUTF8StringEncoding ]];
            [body appendData:[[NSString stringWithFormat:@"Content-ID:<%@>\r\n",attachmentfilename] dataUsingEncoding:NSUTF8StringEncoding ]];
            [body appendData:[[NSString stringWithFormat:@"Content-Transfer-Encoding:base64\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding ]];
            if ([attachmentBase64String isKindOfClass:([TiBlob class])]) {
                [body appendData:[[[attachmentBase64String data] base64EncodedString] dataUsingEncoding:NSUTF8StringEncoding]];
            }else{
                [body appendData:[attachmentBase64String dataUsingEncoding:NSUTF8StringEncoding]];
            }
            _ReleaseObj(attachmentData);
            
        }
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",requestBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
    }
    
    //Send request and handle response
    if(is_debug)
    {
        NSLog(@"[INFO]MoBo All Header Set::%@",[request allHTTPHeaderFields]);
        NSLog(@"[INFO]MoBo Body ::%@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    }
    MessageHTTPRequest* httpRequest = [[MessageHTTPRequest alloc] initRequest:request withDelegate:self];
    [httpRequest autorelease];
    _ReleaseObj(request);
    
    
}

#pragma messageHTTPRequest Methods

- (void) messageRequest:(MessageHTTPRequest*)request didCompleteRequestWithData:(NSData*)data
{
    NSObject *responseObject = nil; 
    NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    switch(acceptType)
    {
        case CONTENTXML:
            responseObject = [NSDictionary dictionaryWithObject:returnString forKey:@"success"];
            break;
        default:
            responseObject = returnString;
            break;
    }
    
    if (successCallback) {
        [successCallback call:[NSArray arrayWithObject:responseObject] thisObject:nil];
    }
    if (successMoBoCallback) {
            [successMoBoCallback call:[NSArray arrayWithObject:responseObject] thisObject:nil];
    }
    _ReleaseObj(returnString);
    [self releaseCallback];
}

- (void) messageRequest:(MessageHTTPRequest*)request didFailWithError:(NSError*)error
{
    [self sendErrorMessage:errorMessage];
}


#pragma mark - 
#pragma mark response handle method 
- (void) sendErrorMessage:(const NSString*)message
{
    NSString *errorString = nil;
    if(message != nil)
        errorString = [NSString stringWithFormat:@"%@",message];
    else     
        errorString = [NSString stringWithFormat:@"%@",@"Error while executing request"];
    if (errorCallback) {
        [errorCallback call:[NSArray arrayWithObject:errorString] thisObject:nil];
    }
    if (errorMoBoCallback) {
        [errorMoBoCallback call:[NSArray arrayWithObject:errorString] thisObject:nil];
    }
    [self releaseCallback];
}

@end


@implementation MessageHTTPRequest

@synthesize mms_response;
@synthesize delegate = _delegate;

#pragma mark-
#pragma mark Http Request
- (id) initRequest:(NSURLRequest*)request withDelegate:(id)delgate
{
    self = [super init];
    self.delegate =  delgate;
    NSURLConnection* urlConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    [urlConnection start];
    return self;
}
- (void) sendMessageWithRequest:(NSURLRequest*)request
{
    NSURLConnection* urlConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    [urlConnection start];
}
- (void) dealloc
{
    _delegate = nil;
    _ReleaseObj(mms_response);
    [super dealloc];
}
#pragma mark - 
#pragma mark connection Delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"#################################################### didFailWithError %@",error);
    if([_delegate conformsToProtocol:@protocol(MessageHTTPHandling)])
        [_delegate messageRequest:self didFailWithError:error];
    
    _ReleaseObj(mms_response);
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"#################################################### didReceiveResponse %@",response);
    _ReleaseObj(mms_response);
    mms_response = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"#################################################### didReceiveData %@",data);
    [mms_response appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"#################################################### connectionDidFinishLoading %@",connection);
    if([_delegate conformsToProtocol:@protocol(MessageHTTPHandling)])
        [_delegate messageRequest:self didCompleteRequestWithData:mms_response];
    _ReleaseObj(mms_response);
}

@end
