//
//  ViewController.m
//
//  Created by dyf on 15/3/23.
//  Copyright (c) 2015 dyf. All rights reserved.
//

#import "ViewController.h"
#import "DFHelper.h"
#import "DFShowViewController.h"
#import "DFLoadingView.h"

@interface ViewController () <DFLoadImageDelegate> {
    NSURL *aUrl;
    DFHelper *aHelper;
    DFLoadingView *loadingView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *url = @"http://c.hiphotos.baidu.com/image/pic/item/a9d3fd1f4134970ada1ced7996cad1c8a7865d7d.jpg";
    aUrl = [[NSURL alloc] initWithString:url];
}

- (IBAction)method1:(id)sender {
    loadingView = [[DFLoadingView alloc] init];
    [loadingView showLoading:self.view animated:YES];
    aHelper = [[DFHelper alloc] init];
    aHelper.delegate = self;
    [aHelper loadImage:aUrl];
}

- (IBAction)method2:(id)sender {
    loadingView = [[DFLoadingView alloc] init];
    [loadingView showLoading:self.view animated:YES];
    aHelper = [[DFHelper alloc] init];
    [aHelper loadImage:aUrl completion:^(NSInteger state, UIImage *image, NSError *error) {
        if (state == Loading_OK) {
            [self showImage:image];
        } else {
            NSLog(@"imageLoading-block error: %@", [error description]);
        }
    }];
}

- (void)imageLoadingDidFinishing:(UIImage *)image {
    [self showImage:image];
}

- (void)imageLoading:(DFHelper *)helper didFailWithError:(NSError *)error {
    NSLog(@"imageLoading-delegate error: %@", [error description]);
}

- (void)showImage:(UIImage *)image {
    DFShowViewController *svc = [[DFShowViewController alloc] init];
    svc.anImage = image;
    [self presentViewController:svc animated:YES completion:^{
        [loadingView dismissLoading:YES];
    }];
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [aUrl release];
    [aHelper release];
    [loadingView release];
    [super dealloc];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
