//
//  DMPQREncodeViewController.m
//  PocketKitchenGod
//
//  Created by Damon on 14-2-23.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPQREncodeViewController.h"

#import <QREncoder.h>

@interface DMPQREncodeViewController ()
@property (nonatomic, copy) NSString * codeString;
@property (nonatomic, copy) NSString * foodName;
@end

@implementation DMPQREncodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (id)initWithCodeString:(NSString *)codeString title:(NSString *)title{
    if (self = [super init]) {
        self.codeString = codeString;
        self.foodName = title;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self createUI];
}
- (void) createUI {
    NSInteger height = 0;
    if (kIsIOS7) {
        height = 64;
    }
    
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, self.view.bounds.size.width, kScreenHeight - 64)];
    bgView.image = [UIImage imageNamed:@"背景图"];
    [self.view addSubview:bgView];
    
    UIImageView* qrcodeImageView = [[UIImageView alloc] initWithImage:[self encodeToImageWithcodeString:self.codeString]];
    [qrcodeImageView setCenter:self.view.center];
    [self.view addSubview:qrcodeImageView];
    
    UILabel * label = [[UILabel alloc] init];
    label.text = @"通过二维码可以分享你最爱的美食哦~";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    label.center = CGPointMake(self.view.center.x, self.view.center.y + 150);
    [self.view addSubview:label];
    

    [self.dmpNavigationBar setDMPNaviBarTitleViewWithTitle:self.foodName signImageName:nil];

}

#pragma mark- 讲字符串转成图片
- (UIImage *) encodeToImageWithcodeString:(NSString *)codeString {
    int qrcodeImageDimension = 250;
    //the string can be very long
    NSString *aVeryLongURL = codeString;

    //first encode the string into a matrix of bools, TRUE for black dot and FALSE for white. Let the encoder decide the error correction level and version
    DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:aVeryLongURL];
    
    //then render the matrix
    UIImage* qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeImageDimension];
    
    return qrcodeImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
