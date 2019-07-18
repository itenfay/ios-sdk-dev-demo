//
//  ViewController.m
//  ExamDemo
//
//  Created by dyf on 15/3/23.
//  Copyright (c) 2015 dyf. All rights reserved.
//

#import "ViewController.h"
#import "DFShowViewController.h"
#import <ExamSimpleSdk/DFHelper.h>
#import <ExamSimpleSdk/DFLoadingView.h>

@interface ViewController () <DFLoadImageDelegate> {
    NSURL *_aUrl;
    DFHelper *_aHelper;
    UIImage *_image;
}
@property (nonatomic, strong) DFLoadingView *loadingView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *url = @"http://c.hiphotos.baidu.com/image/pic/item/a9d3fd1f4134970ada1ced7996cad1c8a7865d7d.jpg";
    _aUrl = [[NSURL alloc] initWithString:url];
}

- (IBAction)method1:(id)sender {
    _loadingView = [[DFLoadingView alloc] init];
    [_loadingView showLoading:self.view animated:YES];
    
    _aHelper = [[DFHelper alloc] init];
    _aHelper.delegate = self;
    [_aHelper loadImage:_aUrl];
}

- (IBAction)method2:(id)sender {
    _loadingView = [[DFLoadingView alloc] init];
    [_loadingView showLoading:self.view animated:YES];
    
    _aHelper = [[DFHelper alloc] init];
    __weak typeof(self) weak_self = self;
    [_aHelper loadImage:_aUrl completion:^(NSInteger state, UIImage *image, NSError *error) {
        if (state == Loading_OK) {
            [weak_self showImage:image];
        } else {
            NSLog(@"imageLoading-block error: %@", [error description]);
            [weak_self.loadingView dismissLoading:YES];
        }
    }];
}

- (void)imageLoadingDidFinishing:(UIImage *)image {
    [self showImage:image];
}

- (void)imageLoading:(DFHelper *)helper didFailWithError:(NSError *)error {
    NSLog(@"imageLoading-delegate error: %@", [error description]);
    [self.loadingView dismissLoading:YES];
}

- (void)showImage:(UIImage *)image {
    DFShowViewController *svc = [[DFShowViewController alloc] init];
    svc.anImage = image;
    [self presentViewController:svc animated:YES completion:^{
        [self.loadingView dismissLoading:YES];
    }];
}

- (void)otherHandle {
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"IlibResource" withExtension:@"bundle"]];
    
    NSString *textPath = [[bundle bundlePath] stringByAppendingPathComponent:@"terms_of_service.txt"];
    NSString *text = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"text: \n%@", text);
    
    NSLog(@"screen.scale: %.0f", [UIScreen mainScreen].scale);
    
    UIImage *image = [UIImage imageNamed:@"twttr-icn-logo"];
    NSLog(@"mainBundle.image.scale: %.0f", image.scale);
    
    NSString *imagePath = [@"IlibResource.bundle" stringByAppendingPathComponent:@"twttr-icn-logo"];
    UIImage *resBundleImage = [UIImage imageNamed:imagePath];
    NSLog(@"resBundle.image.scale: %.0f", resBundleImage.scale);
    
    NSString *imageName = [self formatImageName:@"twttr-icn-logo"];
    NSLog(@"image.name: %@", imageName);
    _image = [UIImage imageWithContentsOfFile:[[bundle bundlePath] stringByAppendingPathComponent:imageName]];
    NSLog(@"image.scale: %.0f", _image.scale);
    
    NSString *masksubPath = [NSString stringWithFormat:@"MBProgressHUD.bundle/%@", @"angle-mask"];
    NSString *maskPath = [@"IlibResource.bundle" stringByAppendingPathComponent:masksubPath];
    UIImage *mask = [UIImage imageNamed:maskPath];
    NSLog(@"image.scale: %.0f", mask.scale);
}

- (NSString *)formatImageName:(NSString *)imageName {
    int scale = (int)[UIScreen mainScreen].scale;
    NSMutableString *formatImageName = [NSMutableString stringWithString:imageName];
    if (scale > 1) {
        [formatImageName appendString:[NSString stringWithFormat:@"@%dx.%@", scale, @"png"]];
    } else {
        [formatImageName appendString:[NSString stringWithFormat:@".%@", @"png"]];
    }
    return formatImageName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
