//
//  ViewController.m
//  XZQRCode_OC
//
//  Created by MYKJ on 17/1/6.
//  Copyright © 2017年 zhaoyongjie. All rights reserved.
//

#import "ViewController.h"
#import "XZQRCodeController.h"

@interface ViewController ()<XZQRCodeDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *scan = [[UIButton alloc] init];
    scan.frame = CGRectMake(100, 100, 60, 40);
    [scan setTitle:@"scan" forState:UIControlStateNormal];
    [scan setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [scan addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scan];
}

- (void)scanClick {
    XZQRCodeController *scan = [[XZQRCodeController alloc] init];
    scan.delegate = self;
    [self.navigationController pushViewController:scan animated:YES];
}


- (void)XZQRCodeScanWithResult:(NSString *)result {
    NSLog(@"result = %@",result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
