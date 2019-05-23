//
//  DFHelper.m
//
//  Created by dyf on 15/3/23.
//  Copyright (c) 2015 dyf. All rights reserved.
//

#import "DFHelper.h"
#import "DFHttpRequest.h"

typedef void (^DFImageLoadingBlock)(NSInteger state, UIImage *image, NSError *error);

@interface DFHelper ()
@property (nonatomic, retain) DFHttpRequest *httpRequest;
@property (nonatomic,  copy ) DFImageLoadingBlock loadingHandler;
@end

@implementation DFHelper
@synthesize httpRequest = _httpRequest;
@synthesize delegate = _delegate;
@synthesize loadingHandler = _loadingHandler;

- (void)loadImage:(NSURL *)url {
    _httpRequest = [[DFHttpRequest alloc] init];
    [_httpRequest sendAsychronousGet:url completionHandler:^(NSInteger state,
                                                             NSData *data,
                                                             NSError *error) {
        if (state == HTTP_OK) {
            UIImage *image = [UIImage imageWithData:data];
            if ([self.delegate respondsToSelector:@selector(imageLoadingDidFinishing:)]) {
                [self.delegate imageLoadingDidFinishing:image];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(imageLoading:didFailWithError:)]) {
                [self.delegate imageLoading:self didFailWithError:error];
            }
        }
    }];
}

- (void)loadImage:(NSURL *)url completion:(void (^)(NSInteger, UIImage *, NSError *))handler {
    self.loadingHandler = handler;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.loadingHandler) self.loadingHandler(Loading_OK, image, error);
            });
        } else {
            if (self.loadingHandler) {
                self.loadingHandler(Loading_Error, nil, error);
            }
        }
    });
}

@end
