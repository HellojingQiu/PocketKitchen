//
//  DMPNetMenuView.m
//  PocketKitchenGod
//
//  Created by Damon on 14-2-17.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPNetMenuView.h"
#define kPointWidth 15
#define kPointHeight 15
#define kSubMenuWidth 203

@implementation DMPNetMenuView

{
    DMPMenuTableView * _mainTableView;   //主菜单
    DMPMenuTableView * _subTableVIew;     //子菜单
    UIImageView *_pointImageView;              //指示标志
    CGFloat _mainTableViewCellHeight;
    BOOL _isFirstUnFold;                                //
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createMenus];
    }
    return self;
}
//折叠
- (void) menuFold {
    CGRect frame = _pointImageView.frame;
    frame.origin.x = kScreenWidth - frame.size.width;
    [UIView animateWithDuration:0.5f animations:^{
        _pointImageView.alpha = 0;
        _pointImageView.frame = frame;
        _mainTableView.frame = CGRectMake(0, 0,self.bounds.size.width, _mainTableView.bounds.size.height);
        _subTableVIew.frame = CGRectMake(320, 0, kSubMenuWidth, _subTableVIew.bounds.size.height);
    }];
    
    _isFirstUnFold = YES;
}
//展开
- (void) menuUnfold {
    [UIView animateWithDuration:0.5f animations:^{
        _mainTableView.frame = CGRectMake(-75,0,192, _mainTableView.bounds.size.height);
        _subTableVIew.frame = CGRectMake((192 - 75), 0, kSubMenuWidth, _subTableVIew.bounds.size.height);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            _pointImageView.alpha = 1;
        }];
    }];
    _isFirstUnFold = NO;
}
//创建两个菜单 即tableView
- (void) createMenus {
    _isFirstUnFold = YES;
    
    _mainTableView = [[DMPMenuTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _subTableVIew = [[DMPMenuTableView alloc] initWithFrame:CGRectMake(320, 0, 192, _mainTableView.bounds.size.height) style:UITableViewStylePlain];
    _pointImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"三角标00"]];
    _pointImageView.alpha = 0;
     [_mainTableView addSubview:_pointImageView];
    _mainTableView.delegate = self;
    _mainTableView.tag = DMPMenuMainTableView;
    _subTableVIew.delegate = self;
    _mainTableView.dataSource = self;
    _subTableVIew.dataSource = self;
    _subTableVIew.tag = DMPMenuSubTableView;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _subTableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:_mainTableView.bounds];
    bgView.image = [UIImage imageNamed:@"Left-bg"];
    _mainTableView.backgroundView = bgView;
    bgView = [[UIImageView alloc] initWithFrame:_subTableVIew.bounds];
    bgView.image = [UIImage imageNamed:@"疾病bg"];
    _subTableVIew.backgroundView = bgView;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _subTableVIew.showsVerticalScrollIndicator = NO;
    [self addSubview:_mainTableView];
    [self addSubview:_subTableVIew];
}

#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DMPMenuTableView * dmpTableView = (DMPMenuTableView *)tableView;
    if ([self.dmpDelegate respondsToSelector:@selector(numberOfRowsForMenuTableView:menuView:)]) {
        return [self.dmpDelegate numberOfRowsForMenuTableView:dmpTableView menuView:self];
    }else
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DMPMenuTableView * dmpTableView = (DMPMenuTableView *)tableView;
        if ([self.dmpDelegate respondsToSelector:@selector(dmpMenuTableView:cellForRowAtIndexPath:menuView:)]) {
            return [self.dmpDelegate dmpMenuTableView:dmpTableView cellForRowAtIndexPath:indexPath menuView:self];
        }else
            return [[UITableViewCell alloc] init];
}
#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DMPMenuTableView * dmpTableView = (DMPMenuTableView *)tableView;
        if ([self.dmpDelegate respondsToSelector:@selector(dmpMenuTableView:heightForRowAtIndexPath:menuView:)]) {
            if (tableView == _mainTableView) {
                _mainTableViewCellHeight = [self.dmpDelegate
                                                                dmpMenuTableView:dmpTableView
                                                                heightForRowAtIndexPath:indexPath
                                                                menuView:self];
            }
            return [self.dmpDelegate dmpMenuTableView:dmpTableView heightForRowAtIndexPath:indexPath menuView:self];
        }else
            return 0;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == _mainTableView && _isFirstUnFold) {
           _pointImageView.alpha = 0;
        [self pointViewMoveToRow:indexPath.row];
        [self menuUnfold];
    } else if (tableView == _mainTableView && !_isFirstUnFold) {
        [self pointViewMoveToRow:indexPath.row];
    }
    DMPMenuTableView * dmpTableView = (DMPMenuTableView *)tableView;
    if ([self.dmpDelegate respondsToSelector:@selector(dmpMenuView:dmpMenuTableView:didSelectRowAtIndexPath:)]) {
        [self.dmpDelegate dmpMenuView:self dmpMenuTableView:dmpTableView didSelectRowAtIndexPath:indexPath];
    }else
        return;
}
//指示图标移动到指定row位置
- (void) pointViewMoveToRow:(NSUInteger)row {
    if (_isFirstUnFold) {
        _pointImageView.frame = [self getFrameFromRow:row];
    }else {
        [UIView animateWithDuration:0.5f animations:^{
            _pointImageView.frame = [self getFrameFromRow:row];
        }];
    }
}
- (CGRect) getFrameFromRow:(NSUInteger)row {
    return CGRectMake(192 - kPointWidth,_mainTableViewCellHeight * row + _mainTableViewCellHeight/2 - 8, kPointWidth,kPointHeight);
}
- (void) mainMenuReload {
    [_mainTableView reloadData];
}
- (void) subMenuReload {
    [_subTableVIew reloadData];
}
@end
