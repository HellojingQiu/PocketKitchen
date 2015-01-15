//
//  DMPSearchTypeButton.m
//  PocketKitchenGod
//
//  Created by Damon on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPSearchTypeButton.h"

@interface DMPSearchTypeButton ()
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL action;

@end
@implementation DMPSearchTypeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setDmpNormalImageName:(NSString *)name
                      selectedImageName:(NSString *)nameH
                                                 title:(NSString *)title
                                              target:(id)target
                                            action:(SEL)action tag:(NSInteger)tag{
    [self.imgBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [self.imgBtn setImage:[UIImage imageNamed:nameH] forState:UIControlStateSelected];
    [self.imgBtn setBackgroundImage:[UIImage imageNamed:@"搜索-分类底"] forState:UIControlStateNormal];
    [self.imgBtn setBackgroundImage:[UIImage imageNamed:@"搜索-分类底-选"] forState:UIControlStateSelected];
    [self.imgBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.tag = tag;
    self.titleLabel.text = title;
    self.target = target;
    self.action = action;
}
- (void) setdmpSearchButtonSeleted:(BOOL)isSelected {
    self.imgBtn.selected = isSelected;
    if (isSelected) {
        self.titleLabel.textColor = [UIColor whiteColor];
    }else
        self.titleLabel.textColor = [UIColor grayColor];
}
- (void) BtnClick:(UIButton *)btn {
    if ([self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action withObject:self];
    }
}
- (void)layoutSubviews {
    self.imgBtn.frame = self.bounds;
    self.titleLabel.frame = CGRectMake(0, self.bounds.size.height - self.titleLabel.bounds.size.height, self.bounds.size.width, self.titleLabel.bounds.size.height);
}

@end
