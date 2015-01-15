//
//  DMPSearchTypeScrollView.m
//  PocketKitchenGod
//
//  Created by Damon on 14-2-19.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPSearchTypeScrollView.h"
#import "DMPSearchTypeButton.h"

const int DMPSearchBtnWidth = 65;

@interface DMPSearchTypeScrollView ()

@end
@implementation DMPSearchTypeScrollView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
     WithImageNames:(NSArray *)names
      isTitleHidden:(BOOL)isHidden
             target:(id)target
             action:(SEL)action{
    
    self = [self initWithFrame:frame];
    if (self) {
        self.backgroundColor= [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        [self createButtonWithImageName:names isTItleHidden:isHidden target:target action:action];
    }
    return self;
}
- (void)createButtonWithImageName:(NSArray *)names
                    isTItleHidden:(BOOL)isHidden
                           target:(id)target
                           action:(SEL)action {
    
    self.target = target;
    self.action = action;
    
    for (int i = 0; i < names.count; i ++) {
        DMPSearchTypeButton * btn = [[[NSBundle mainBundle] loadNibNamed:@"DMPSearchTypeButton" owner:self options:nil] lastObject];
        NSString *title = @"";
        if (!isHidden) {
            NSString *name = names[i];
            NSArray *subString = [name componentsSeparatedByString:@"-"];
            title = [subString lastObject];
        }
        [btn setDmpNormalImageName:names[i] selectedImageName:[NSString stringWithFormat:@"%@1",names[i]] title:title target:self action:@selector(btnPress:) tag:i];
        btn.frame = CGRectMake(i * (DMPSearchBtnWidth + 5),0, DMPSearchBtnWidth, DMPSearchBtnWidth);
        [self addSubview:btn];
        if (i ==  names.count -1) {
            self.contentSize = CGSizeMake(btn.frame.origin.x + btn.frame.size.width + 40, self.bounds.size.height);
        }
    }
}
- (void) btnPress:(DMPSearchTypeButton *)btn {
    self.currentSelectedIndex = btn.tag;
    if ([self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action withObject:self];
    }
    [self resetBtnState];
    [btn setdmpSearchButtonSeleted:YES];
}
- (void)resetBtnState {
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[DMPSearchTypeButton class]]) {
            DMPSearchTypeButton * btn = (DMPSearchTypeButton *)view;
            [btn setdmpSearchButtonSeleted:NO];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
