//
//  DMPBottomBar.m
//  PocketKitchenGod
//
//  Created by Damon on 14-2-16.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPBottomBar.h"
#import "DMPBottomModel.h"
@interface DMPBottomBar ()

@property (weak, nonatomic) IBOutlet UIButton *BtnA;
@property (weak, nonatomic) IBOutlet UIButton *BtnB;
@property (weak, nonatomic) IBOutlet UIButton *BtnC;
@property (weak, nonatomic) IBOutlet UIButton *BtnD;
@property (weak, nonatomic) IBOutlet UIButton *BtnE;
@property (weak, nonatomic) IBOutlet UILabel *TimeMenuLabel;

@end
@implementation DMPBottomBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setItemsWithModels:(NSArray *)models {
    NSUInteger tagLoc = 201;
    for (DMPBottomModel * model in models) {
        UIButton * btn = (UIButton *)[self viewWithTag:tagLoc];
        if (tagLoc != 205) {
            [btn setBackgroundImage:[UIImage imageNamed:model.imageName] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:model.imageNameH] forState:UIControlStateHighlighted];
        }
        [btn addTarget:model.target action:model.action forControlEvents:UIControlEventTouchUpInside];
        btn.tag = model.tag;
        tagLoc ++;
    }
    NSDate * date = [NSDate date];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM"];
    NSString * monthNum = [format stringFromDate:date];
    self.TimeMenuLabel.text = [NSString stringWithFormat:@"%@月菜单",monthNum];
}
@end
