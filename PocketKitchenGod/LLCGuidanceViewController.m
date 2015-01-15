//
//  LLCGuidanceViewController.m
//  PocketKitchenGod
//
//  Created by yxx on 14-2-16.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "LLCGuidanceViewController.h"
#import "QFTableView.h"
#import "LLCMainViewController.h"

@interface LLCGuidanceViewController ()
<QFTableViewDataSource,
QFTableViewDelegate>
{
  NSArray *_guidanceImages;
  
  QFTableView *_tableView;
  
  NSInteger _currentIndex;
}
@end

@implementation LLCGuidanceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self loadPictures];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self layoutSelf];
  [self tableViewConfig];
}

#pragma mark QFTable View Delegate
- (void)QFTableView:(QFTableView *)fanView scrollToIndex:(NSInteger)index {
  _currentIndex = index;
}

#pragma mark QFTable View DataSource
- (CGFloat)QFTableView:(QFTableView *)fanView
         widthForIndex:(NSInteger)index {
  return 320;
}

- (NSInteger)numberOfIndexForQFTableView:(QFTableView *)fanView {
  return _guidanceImages.count;
}

- (void)QFTableView:(QFTableView *)fanView
     setContentView:(UIView *)contentView
           ForIndex:(NSInteger)index {
  
  UIImageView *guidanceView = (UIImageView *)contentView;
  
  NSString *path = [[NSBundle mainBundle] bundlePath];
  path = [NSString stringWithFormat:@"%@/%@", path, [_guidanceImages objectAtIndex:index]];
  guidanceView.image = [UIImage imageWithContentsOfFile:path];
}

- (UIView *)QFTableView:(QFTableView *)fanView
             targetRect:(CGRect)targetRect
               ForIndex:(NSInteger)index {
  UIImageView *guidanceView = [[UIImageView alloc] initWithFrame:targetRect];
  guidanceView.userInteractionEnabled = YES;
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goMainView:)];
  [guidanceView addGestureRecognizer:tap];
  
  return guidanceView;
}


#pragma mark - Private
- (void)loadPictures {
  _guidanceImages = [NSArray arrayWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"GuidancePlist"
                                                     ofType:@"plist"]];
}

- (void)layoutSelf {
  
}

- (void)tableViewConfig {
  _tableView = [[QFTableView alloc] initWithFrame:self.view.bounds];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  
  _tableView.pagingEnabled = YES;
  
  [self.view addSubview:_tableView];
  
  [_tableView reloadData];
}

- (void)goMainView:(UITapGestureRecognizer *)tap {
  if (_currentIndex == _guidanceImages.count-1) {
    CGPoint pos = [tap locationInView:tap.view];
    
    CGRect theFrame = CGRectMake(42, 495, 237, 55);
    if (CGRectContainsPoint(theFrame, pos)) {
      
      LLCMainViewController *mainView = [[LLCMainViewController alloc] init];
      UIWindow *window = kApplication.keyWindow;
      window.rootViewController = mainView;
    }
  }
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end
