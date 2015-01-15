//
//  DMPSubIIRootViewController.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPSubIIRootViewController.h"
#import "UIButton+KitButton.h"
@interface DMPSubIIRootViewController ()

@end

@implementation DMPSubIIRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton * btn = [UIButton createKitButtonWithBackgroundImageNameForNormal:@"home"
                                                                     highlight:@"home-selected"
                                                                   bottomTitle:nil];
    [btn addTarget:self action:@selector(homeBtnPress) forControlEvents:UIControlEventTouchUpInside];
}
- (void) homeBtnPress {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
