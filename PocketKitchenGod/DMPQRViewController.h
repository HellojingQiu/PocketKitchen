//
//  DMPQRViewController.h
//  PocketKitchenGod
//
//  Created by Damon on 14-2-23.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import <ZXingWidgetController.h>
#import <Decoder.h>
@class DMPNavigationBar;
//扫描二维码VC类
//继承于ZXingWidgetController,Zxing官方封装了的一个扫描VC
@class DMPQRViewController;
@protocol DMPQRViewControllerDelegate <NSObject>

- (void)dmpQRViewController:(DMPQRViewController *)qrVC didFinishPickingImage:(UIImage *)image;

@end

@interface DMPQRViewController : ZXingWidgetController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) id<DMPQRViewControllerDelegate>dmpDelegate;
@property (nonatomic, strong) DMPNavigationBar * dmpNavigationBar;  //导航栏
@end
