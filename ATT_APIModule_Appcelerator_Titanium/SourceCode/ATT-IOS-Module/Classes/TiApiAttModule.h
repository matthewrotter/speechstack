/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"

@class MessageHTTPRequest;
@protocol MessageHTTPHandling <NSObject>

- (void) messageRequest:(MessageHTTPRequest*)request didCompleteRequestWithData:(NSData*)data;
- (void) messageRequest:(MessageHTTPRequest*)request didFailWithError:(NSError*)error;

@end

@interface MessageHTTPRequest:NSObject
{
@private
    NSMutableData*      mms_response;
    id                  delegate;
}

@property (nonatomic,readonly)  NSMutableData*    mms_response;
@property (nonatomic,assign)  id    delegate;

- (id) initRequest:(NSURLRequest*)request withDelegate:(id)delegate;
- (void) sendMessageWithRequest:(NSURLRequest*)request;
@end


@interface TiApiAttModule : TiModule <NSURLConnectionDelegate,NSURLConnectionDataDelegate,MessageHTTPHandling>
{
    KrollCallback *successCallback;
    KrollCallback *errorCallback;
    KrollCallback *successMoBoCallback;
    KrollCallback *errorMoBoCallback;
@private
    NSMutableData*      mms_response;
    bool                is_debug;
    NSUInteger          acceptType;
}

/** 
 * Name:sendMMS
 * Description:It allows to send MMS messages to AT&T Mobile subscribe network.
 * Argument (args):Array contains MMS parameter with success and failure callback.
 * Return  :void
 */
-(void)sendMMS:(id)args;

/** 
 * Name:sendMessage
 * Description:It allows to send SMS and MMS messages to AT&T Mobile subscribe network.
 * Argument (args):Array contains MOBO parameter with success and failure callback.
 * Return  :void
 */
- (void)sendMessage:(id)args;

/** 
 * Name:setDebug
 * Description:It allows your applications to enable the debug.
 * Argument (args):Bool Value.
 * Return  :void
 */
- (void) setDebug:(id)debug;
@end
