XZQRCode_OC
===
### 轻量级iOS原生二维码扫一扫

## Swift版本
Swift版本的二维码扫描请移步[XZQRCode_Swift](https://github.com/zyj179638121/XZQRCode_Swift.git)


## 集成说明
你可以在`Podfile`中加入下面一行代码来使用`XZQRCode_OC`

	pod 'XZQRCode_OC'
	
你也可以手动添加源码使用本项目，将开源代码中的`XZQRCodeController.h`和`XZQRCodeController.m`添加到你的工程中。

## 使用说明

导入头文件

```Objective-C
#import "XZQRCodeController.h"
```
创建扫一扫控制器对象

```Objective-C
XZQRCodeController *scan = [[XZQRCodeController alloc] init];
scan.delegate = self;
[self.navigationController pushViewController:scan animated:YES];

```
遵守协议

```Objective-C
@interface ViewController ()<XZQRCodeDelegate>

```
在代理方法中对回调结果进行相应的处理

```Objective-C
- (void)XZQRCodeScanWithResult:(NSString *)result {
    NSLog(@"result = %@",result);
}
```



