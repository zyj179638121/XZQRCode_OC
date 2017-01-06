//
//  XZQRCodeController.h
//  XZQRCode_OC
//
//  Created by MYKJ on 17/1/6.
//  Copyright © 2017年 zhaoyongjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XZQRCodeDelegate <NSObject>

- (void)XZQRCodeScanWithResult:(NSString *)result;

@end

@interface XZQRCodeController : UIViewController

@property (nonatomic, weak) id<XZQRCodeDelegate> delegate;

@end
