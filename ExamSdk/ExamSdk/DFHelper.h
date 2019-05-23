//
//  DFHelper.h
//
//  Created by dyf on 15/3/23.
//  Copyright (c) 2015 dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ImageLoadingState) {
    Loading_OK    = 1,
    Loading_Error = 2
};

@protocol DFLoadImageDelegate;

@interface DFHelper : NSObject

@property (nonatomic, assign) id<DFLoadImageDelegate>delegate;

/**
 *	@brief	使用Http协议
 */
- (void)loadImage:(NSURL *)url;

/**
 *	@brief	使用Block语法
 */
- (void)loadImage:(NSURL *)url completion:(void (^)(NSInteger state, UIImage *image, NSError *error))handler;

@end

@protocol DFLoadImageDelegate <NSObject>

- (void)imageLoadingDidFinishing:(UIImage *)image;

@optional
- (void)imageLoading:(DFHelper *)helper didFailWithError:(NSError *)error;

@end
