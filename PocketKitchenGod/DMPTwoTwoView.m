//
//  DMPTwoTwoView.m
//  PocketKitchenGod
//
//  Created by Damon's on 14-2-18.
//  Copyright (c) 2014年 yxx. All rights reserved.
//

#import "DMPTwoTwoView.h"
const int kTableViewLeft = 44;
const int kTableViewRight = 45;
const int kLoadMoreOffY = 70;
@implementation DMPTwoTwoView{
    UIImageView * _divisionView;
    BOOL _autoAdjust;
    CGFloat _cellHeight;
}

- (id)initWithFrame:(CGRect)frame style:(DMPTwoTwoStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dmpTwoTwoStyle = style;
        _autoAdjust = NO;
        self.backgroundColor = [UIColor clearColor];
        [self createTableView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame style:(DMPTwoTwoStyle)style autoAdjust:(BOOL)autoAdjust {
    self = [self initWithFrame:frame style:style];
    _autoAdjust = autoAdjust;
    return self;
}
- (void)createTableView {
    for (int i = 0; i < 2; i ++) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * self.bounds.size.width/2,0,self.bounds.size.width/2,self.bounds.size.height) style:UITableViewStylePlain];
    
        tableView.tag = i > 0?kTableViewRight:kTableViewLeft;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:tableView];
    }
    
    _divisionView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 1, 5, 2, self.bounds.size.height - 10)];
    [self addSubview:_divisionView];
}



- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    BOOL isLeft;
    if (tableView.tag == kTableViewLeft) {
        isLeft = YES;
    }else
        isLeft = NO;
    if ([self.delegate respondsToSelector:@selector(dmpTwoTwoView:numberOfRowIsLeft:)]) {
        return [self.delegate dmpTwoTwoView:self numberOfRowIsLeft:isLeft];
    }
    return 0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIde = @"cell";
    Class class;
    if ([self.delegate respondsToSelector:@selector(dmpTwoTwoView:classOfCellAndIdentifier:)]) {
        class = [self.delegate dmpTwoTwoView:self classOfCellAndIdentifier:cellIde];
    }else
        class = [UITableViewCell class];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(class) owner:self options:nil] lastObject];
    }
    BOOL isLeft;
    if ([self.delegate respondsToSelector:@selector(dmpTwoTwoView:Cell:ForRowIndex:isLeft:)]) {
        if (tableView.tag == kTableViewLeft) {
            isLeft = YES;
        }else
            isLeft = NO;
        [self.delegate dmpTwoTwoView:self Cell:cell ForRowIndex:indexPath.row isLeft:isLeft];
    }
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isLeft;
    if (tableView.tag == kTableViewLeft) {
        isLeft = YES;
    }else
        isLeft = NO;
    
    _cellHeight = [self.delegate dmpTwoTwoView:self HeightForIndex:indexPath.row isLeft:isLeft];
    return _cellHeight;
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(dmpTwoTwoView:DidSeletedAtIndex:isLeft:)]) {
        BOOL isLeft;
        if (tableView.tag == kTableViewLeft) {
            isLeft = YES;
        }else
            isLeft = NO;
        [self.delegate dmpTwoTwoView:self DidSeletedAtIndex:indexPath.row isLeft:isLeft];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.dmpTwoTwoStyle == DMPTwoTwoStyleDependent) {
        //联动
        UITableView * tableViewLeft = (UITableView *)[self viewWithTag:kTableViewLeft];
        UITableView * tableViewRight = (UITableView *)[self viewWithTag:kTableViewRight];
        tableViewLeft.contentOffset = scrollView.contentOffset;
        tableViewRight.contentOffset = scrollView.contentOffset;
    }else {
        //非联动
    }
    if (scrollView.contentOffset.y + scrollView.bounds.size.height > scrollView.contentSize.height + kLoadMoreOffY ) {
        if ([self.delegate respondsToSelector:@selector(dmpTwoTwoView:needToLoadMoreIsLeft:)]) {
            BOOL isLeft;
            if (scrollView.tag == kTableViewLeft) {
                isLeft = YES;
            }else
                isLeft = NO;
            if ([self.delegate dmpTwoTwoView:self needToLoadMoreIsLeft:isLeft]) {
                //允许loadMore,重读数据
                if (isLeft) {
                    [self reloadTableViewLeft];
                }else
                    [self reloadTableViewRight];
            }
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self autoAdjustContentOffForScrollView:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self autoAdjustContentOffForScrollView:scrollView];
    }
}
#pragma mark -自动调整位移
- (void)autoAdjustContentOffForScrollView:(UIScrollView *)scrollView {
    NSInteger height = _cellHeight;
    if (_autoAdjust && height) {
        NSInteger pointY = scrollView.contentOffset.y;
        NSInteger cellHeight = _cellHeight;
        NSInteger distanceV = pointY % cellHeight;
        [UIView animateWithDuration:0.2f animations:^{
            if ( distanceV <= cellHeight/2) {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y - distanceV);
            }else{
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + (cellHeight - distanceV));
            }
        }];
    }

}
- (void) reloadTableViewLeft {
    UITableView * tableViewLeft = (UITableView *)[self viewWithTag:kTableViewLeft];
    [tableViewLeft reloadData];
}
- (void) reloadTableViewRight {
    UITableView * tableViewRight = (UITableView *)[self viewWithTag:kTableViewRight];
    [tableViewRight reloadData];
}
#pragma mark- 外部
- (void)reloadDataOnLeft:(BOOL)left {
    if (left) {
        [self reloadTableViewLeft];
    }else
        [self reloadTableViewRight];
}
- (void)reloadDataBoth {
    [self reloadTableViewLeft];
    [self reloadTableViewRight];
}
- (void)setTwoTwoViewDivisionWithImageName:(NSString *)name {
    _divisionView.image = [UIImage imageNamed:name];
}
@end
