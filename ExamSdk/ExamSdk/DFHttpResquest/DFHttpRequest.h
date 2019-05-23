//
//  DFHttpRequest.h
//
//  Created by dyf on 15/2/2.
//  Copyright (c) 2015年 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HTTP_OK    = 0,
    HTTP_ERROR = 1
} UQHTTPState;

//get error message 
extern NSString *const kHTTPRequestError;

@interface DFHttpRequest : NSObject
//request timeout interval
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
//accept language for HTTPHeader
@property (nonatomic, copy) NSString *acceptLanguage;

/**
 *	@brief	Asynchronous Get Request
 *	@param 	aURL url
 */
- (void)sendAsychronousGet:(NSURL *)aURL completionHandler:(void (^)(NSInteger state, NSData *data, NSError *error))handler;

/**
 *	@brief	Asynchronous Post Request
 *	@param 	aURL 	url
 *	@param 	params 	post data
 */
- (void)sendAsychronousPost:(NSURL *)aURL addParams:(NSData *)params completionHandler:(void (^)(NSInteger state, NSData *data, NSError *error))handler;

@end
