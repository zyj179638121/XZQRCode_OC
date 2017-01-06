//
//  XZQRCodeController.m
//  XZQRCode_OC
//
//  Created by MYKJ on 17/1/6.
//  Copyright © 2017年 zhaoyongjie. All rights reserved.
//

#import "XZQRCodeController.h"
#import <AVFoundation/AVFoundation.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define QRCodeWidth  260.0

@interface XZQRCodeController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

@end

@implementation XZQRCodeController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 启动会话
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.session stopRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"扫一扫";
    
    // 设置扫描区域之外的阴影视图
    [self setupMaskView];
    
    // 设置扫描二维码区域的视图
    [self setupScanWindowView];
    
    // 开始扫二维码
    [self beginScanning];
}

- (void)setupMaskView
{
    //设置统一的视图颜色和视图的透明度
    UIColor *color = [UIColor blackColor];
    float alpha = 0.7;
    
    //设置扫描区域外部上部的视图
    UIView *topView = [[UIView alloc]init];
    topView.frame = CGRectMake(0, 0, kScreenW, (kScreenH - 64 - QRCodeWidth)/2.0);
    topView.backgroundColor = color;
    topView.alpha = alpha;
    
    //设置扫描区域外部左边的视图
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0, topView.frame.size.height , (kScreenW - QRCodeWidth)/2.0, QRCodeWidth);
    leftView.backgroundColor = color;
    leftView.alpha = alpha;
    
    //设置扫描区域外部右边的视图
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake((kScreenW - QRCodeWidth)/2.0 + QRCodeWidth, topView.frame.size.height, (kScreenW - QRCodeWidth)/2.0,QRCodeWidth);
    rightView.backgroundColor = color;
    rightView.alpha = alpha;
    
    //设置扫描区域外部底部的视图
    UIView *botView = [[UIView alloc] init];
    botView.frame = CGRectMake(0, QRCodeWidth + topView.frame.size.height, kScreenW, kScreenH - QRCodeWidth - topView.frame.size.height);
    botView.backgroundColor = color;
    botView.alpha = alpha;
    
    //将设置好的扫描二维码区域之外的视图添加到视图图层上
    [self.view addSubview:topView];
    [self.view addSubview:leftView];
    [self.view addSubview:rightView];
    [self.view addSubview:botView];
}

- (void)setupScanWindowView
{
    //设置扫描区域的位置(考虑导航栏和电池条的高度为64)
    UIView *scanWindow = [[UIView alloc]initWithFrame:CGRectMake((kScreenW - QRCodeWidth)/2.0, (kScreenH - 64 - QRCodeWidth)/2.0, QRCodeWidth, QRCodeWidth)];
    scanWindow.clipsToBounds = YES;
    [self.view addSubview:scanWindow];
    
    UILabel *QRDesLabel = [[UILabel alloc] init];
    QRDesLabel.frame = CGRectMake(0, scanWindow.frame.origin.y + QRCodeWidth + 10, kScreenW, 30);
    QRDesLabel.textAlignment = NSTextAlignmentCenter;
    QRDesLabel.textColor = [UIColor whiteColor];
    QRDesLabel.font = [UIFont systemFontOfSize:12];
    QRDesLabel.text = @"将二维码放入框内,即可自动扫描";
    [self.view addSubview:QRDesLabel];
    
    //设置扫描区域的动画效果
    CGFloat scanNetImageViewW = scanWindow.frame.size.width;
    UIImageView *scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QRCodeScanLine"]];
    scanNetImageView.frame = CGRectMake(0, 0, scanNetImageViewW, 15);
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
    scanNetAnimation.keyPath =@"transform.translation.y";
    scanNetAnimation.byValue = @(QRCodeWidth);
    scanNetAnimation.duration = 2.5;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [scanNetImageView.layer addAnimation:scanNetAnimation forKey:nil];
    [scanWindow addSubview:scanNetImageView];
    
    //设置扫描区域的四个角的边框
    CGFloat buttonWH = 18;
    UIImageView *topLeftImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScanQR1"]];
    topLeftImgView.frame = CGRectMake(0,0, buttonWH, buttonWH);
    [scanWindow addSubview:topLeftImgView];
    
    UIImageView *topRightImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScanQR2"]];
    topRightImgView.frame = CGRectMake(QRCodeWidth - buttonWH,0, buttonWH, buttonWH);
    [scanWindow addSubview:topRightImgView];
    
    UIImageView *bottomLeftImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScanQR3"]];
    bottomLeftImgView.frame = CGRectMake(0,QRCodeWidth - buttonWH, buttonWH, buttonWH);
    [scanWindow addSubview:bottomLeftImgView];
    
    UIImageView *bottomRightImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScanQR4"]];
    bottomRightImgView.frame = CGRectMake(QRCodeWidth - buttonWH, QRCodeWidth - buttonWH, buttonWH, buttonWH);
    [scanWindow addSubview:bottomRightImgView];
}

- (void)beginScanning
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        //防止模拟器崩溃
        NSLog(@"没有摄像头设备");
        return;
    }
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //特别注意的地方：有效的扫描区域，定位是以设置的右顶点为原点。屏幕宽所在的那条线为y轴，屏幕高所在的线为x轴
    CGFloat x = ((kScreenH - QRCodeWidth)/2.0)/kScreenH;
    CGFloat y = ((kScreenW - QRCodeWidth)/2.0)/kScreenW;
    CGFloat width = QRCodeWidth/kScreenH;
    CGFloat height = QRCodeWidth/kScreenW;
    output.rectOfInterest = CGRectMake(x, y, width, height);
    
    //设置代理在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_session stopRunning];
        //得到二维码上的所有数据
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0 ];
        NSString *str = metadataObject.stringValue;
        [self.navigationController popViewControllerAnimated:YES];
        if ([self.delegate respondsToSelector:@selector(XZQRCodeScanWithResult:)]) {
            [self.delegate XZQRCodeScanWithResult:str];
        }
    }
}


@end
