//
//  LLCHeaderScrollView.m
//  标签栏
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCHeaderScrollView.h"
#import "LLCHeaderButton.h"

#define kButtonWidth 80

@implementation LLCHeaderScrollView

const int kBaseCount = 300;

- (id)initWithFrame:(CGRect)frame
    itemsNormalImageName:(NSArray *)normalImageNames
  itemsSelectedImageName:(NSArray *)selectedImageNames
             titles:(NSArray *)titles {
  
  self = [super initWithFrame:frame];
  if (self) {
    
    for (int i = 0; i < titles.count; i++) {
      LLCHeaderButton *btn = [[[NSBundle mainBundle] loadNibNamed:@"LLCHeaderButton"
                                                            owner:self
                                                          options:nil] lastObject];
      [btn.headerButton setBackgroundImage:
       [UIImage imageNamed:[normalImageNames objectAtIndex:i]]
                                  forState:UIControlStateNormal];
      [btn.headerButton setBackgroundImage:
       [UIImage imageNamed:[selectedImageNames objectAtIndex:i]]
                                  forState:UIControlStateHighlighted];
      btn.headerLabel.text = [titles objectAtIndex:i];
      btn.center = CGPointMake(kButtonWidth/2.+i*(kButtonWidth), self.frame.size.height/2);
      btn.headerButton.tag = kBaseCount+i;
      [btn.headerButton addTarget:self
                           action:@selector(btnPressed:)
                 forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:btn];
    }
    
  }
  return self;
}

- (void)btnPressed:(UIButton *)button {
  if ([self.llcHeaderScrollViewDelegate respondsToSelector:@selector(llcHeaderScrollViewDidSelectedItemAtIndex:)]) {
    [self.llcHeaderScrollViewDelegate llcHeaderScrollViewDidSelectedItemAtIndex:button.tag-kBaseCount];
  }
}

@end
