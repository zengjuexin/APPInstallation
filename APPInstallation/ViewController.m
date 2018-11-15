//
//  ViewController.m
//  APPInstallation
//
//  Created by 曾觉新 on 2018/11/2.
//  Copyright © 2018 曾觉新. All rights reserved.
//

#import "ViewController.h"
#import "JXAPPInstallation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSLog(@"%d", [JXAPPInstallation isInstalled:@"com.RongTeng.rxgou"]);
    
}


@end
