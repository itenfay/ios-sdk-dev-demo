//
//  DFShowViewController.m
//  ExamDemo
//
//  Created by dyf on 15/3/23.
//  Copyright (c) 2015 dyf. All rights reserved.
//

#import "DFShowViewController.h"

@interface DFShowViewController ()

@end

@implementation DFShowViewController

- (void)dealloc {
    NSLog(@"df: dealloc");
}

- (instancetype)init {
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"IlibResource" withExtension:@"bundle"]];
    self = [super initWithNibName:@"DFShowViewController" bundle:bundle];
    if (self) {
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.anImageView.image = self.anImage;
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        self.anImageView = nil;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
