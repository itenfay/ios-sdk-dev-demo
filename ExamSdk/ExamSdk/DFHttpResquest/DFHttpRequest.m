//
//  DFHttpRequest.m
//
//  Created by dyf on 15/2/2.
//  Copyright (c) 2015 dyf. All rights reserved.
//

#import "DFHttpRequest.h"

#if __has_feature(objc_arc)
#define DFAUTORELEASE(X) (X)
#else
#define DFAUTORELEASE(X) [(X) autorelease]
#endif

#define HTTP_STATUS_OK 200

typedef enum {
    HTTP_GET  = 0,
    HTTP_POST = 1
} DFHTTPMethod;

static NSString *const kHTTPHeaderLanguage = @"zh";
NSString *const kHTTPRequestError = @"EncodedProcessMessage";

typedef void (^DFHTTPResponseResultHandler)(NSInteger state, NSData *data, NSError *error);

@interface DFHttpRequest () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSData *HTTPBody;
@property (nonatomic, strong) NSMutableData *result;
@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic,  copy ) DFHTTPResponseResultHandler resultHandler;
@end

@implementation DFHttpRequest
@synthesize url;
@synthesize HTTPBody;
@synthesize result;
@synthesize urlConnection;
@synthesize resultHandler;
@synthesize timeoutInterval;
@synthesize acceptLanguage;

- (void)dealloc {
    self.url            = nil;
    self.HTTPBody       = nil;
    self.result         = nil;
    self.urlConnection  = nil;
    self.resultHandler  = nil;
    self.acceptLanguage = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeoutInterval = 10.f;
        self.acceptLanguage = kHTTPHeaderLanguage;
        self.result = [NSMutableData dataWithCapacity:0];
    }
    return self;
}

- (void)sendAsychronousGet:(NSURL *)aURL completionHandler:(void (^)(NSInteger, NSData *, NSError *))handler
{
    self.url = aURL;
    self.resultHandler = handler;
    [self startAsychronousRequest:HTTP_GET];
}

- (void)sendAsychronousPost:(NSURL *)aURL addParams:(NSData *)params completionHandler:(void (^)(NSInteger, NSData *, NSError *))handler
{
    self.url = aURL;
    self.HTTPBody = params;
    self.resultHandler = handler;
    [self startAsychronousRequest:HTTP_POST];
}

- (void)startAsychronousRequest:(DFHTTPMethod)method
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeoutInterval];
    
    switch (method) {
        case HTTP_GET:
            [request setHTTPMethod:@"GET"];
            break;
        case HTTP_POST:
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:self.HTTPBody];
            [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            break;
        default:
            break;
    }
    
    [request setValue:self.acceptLanguage forHTTPHeaderField:@"Accept-Language"];
    self.urlConnection = DFAUTORELEASE([[NSURLConnection alloc] initWithRequest:request
                                                                       delegate:self
                                                               startImmediately:NO]);
    [[NSRunLoop currentRunLoop] runMode:NSRunLoopCommonModes beforeDate:[NSDate distantFuture]];
    [self.urlConnection start];
}

- (void)cancelAsychronousRequest
{
    if (self.urlConnection) {
        [self.urlConnection cancel];
    }
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSString *authMethod = challenge.protectionSpace.authenticationMethod;
    if ([authMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [self trustHTTPSRequest:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.result setLength:0];
    
    NSHTTPURLResponse *HTTPURLResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = HTTPURLResponse.statusCode;
    
    if (statusCode != HTTP_STATUS_OK) {
        NSDictionary *fields = HTTPURLResponse.allHeaderFields;
        NSError *error = [NSError errorWithDomain:self.url.host code:statusCode userInfo:fields];
        
        if (self.resultHandler) {
            self.resultHandler(HTTP_ERROR, nil, error);
        }
        
        [self cancelAsychronousRequest];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.result appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.resultHandler) {
        self.resultHandler(HTTP_OK, self.result, nil);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.result setLength:0];
    if (self.resultHandler) {
        self.resultHandler(HTTP_ERROR, nil, error);
    }
}

- (void)trustHTTPSRequest:(NSURLAuthenticationChallenge *)challenge
{
    NSURLCredential *credential;
    NSURLProtectionSpace *protectionSpace;
    SecTrustRef trust;
    
    assert(challenge != nil);
    protectionSpace = [challenge protectionSpace];
    assert(protectionSpace != nil);
    trust = [protectionSpace serverTrust];
    assert(trust != NULL);
    credential = [NSURLCredential credentialForTrust:trust];
    assert(credential != nil);
    
    if (SecTrustGetCertificateCount(trust) > 0) {
        SecTrustGetCertificateAtIndex(trust, 0);
    }
    
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

@end
