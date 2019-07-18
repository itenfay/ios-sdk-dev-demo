//
//  DFHttpRequest.h
//
//  Created by dyf on 15/2/2.
//  Copyright (c) 2015 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HTTP_OK    = 0,
    HTTP_ERROR = 1
} DFHTTPState;

// Get error message.
extern NSString *const kHTTPRequestError;

@interface DFHttpRequest : NSObject
// Request timeout interval.
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
// Accept language for HTTP header.
@property (nonatomic, copy) NSString *acceptLanguage;

/**
 *	@brief	Asynchronous Get Request.
 *	@param 	aURL url
 */
- (void)sendAsychronousGet:(NSURL *)aURL completionHandler:(void (^)(NSInteger state, NSData *data, NSError *error))handler;

/**
 *	@brief	Asynchronous Post Request.
 *	@param 	aURL 	url
 *	@param 	params 	post data parameters
 */
- (void)sendAsychronousPost:(NSURL *)aURL addParams:(NSData *)params completionHandler:(void (^)(NSInteger state, NSData *data, NSError *error))handler;

@end
