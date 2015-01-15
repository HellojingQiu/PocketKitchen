//
//  LLCVideoRootViewController.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCVideoRootViewController.h"

@interface LLCVideoRootViewController ()

@end

@implementation LLCVideoRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

#pragma mark - QFTableView Delegate
- (CGFloat)QFTableView:(QFTableView *)fanView
         widthForIndex:(NSInteger)index {
  return 0;
}

- (NSInteger)numberOfIndexForQFTableView:(QFTableView *)fanView {
  return 0;
}

- (UIView *)QFTableView:(QFTableView *)fanView
             targetRect:(CGRect)targetRect
               ForIndex:(NSInteger)index {
  return nil;
}

- (void)QFTableView:(QFTableView *)fanView
     setContentView:(UIView *)contentView
           ForIndex:(NSInteger)index {
  return;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self tableViewConfig];
}

#pragma mark - 表示图布局
- (void)tableViewConfig {
  
  _tableView = [[QFTableView alloc] initWithFrame:CGRectMake(
                                       0,
                                       20+44,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height-20-44-44)];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  
  _tableView.pagingEnabled = YES;
  
  [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
