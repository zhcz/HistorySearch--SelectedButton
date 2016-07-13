//
//  ZZHistoryViewController.m
//  Search
//
//  Created by zz on 16/7/13.
//  Copyright © 2016年 zhcz. All rights reserved.
//

#import "ZZHistoryViewController.h"
#import "ZZFlow.h"
@interface ZZHistoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView    *_collectionView;   //流布局视图
    NSMutableArray      *_dataArr;          //流布局数据源
}

@end

@implementation ZZHistoryViewController

-(id)initWithFrame:(CGRect)frame andItems:(NSArray *)items andItemClickBlock:(itemClickBlock)click{
    
    if (self == [super initWithFrame:frame]) {
        _dataArr                    = [NSMutableArray arrayWithArray:items];
        _itemClick                  = click;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self configBaseView];
    }
    return self;
}


/**
 *  搭建基本视图
 */
- (void)configBaseView{
    self.backgroundColor            = [UIColor whiteColor];
    
    /* 自定义布局格式 */
    ZZFlow *flow              = [[ZZFlow alloc] init];
    flow.minimumLineSpacing         = 5;
    flow.minimumInteritemSpacing    = 5;
    
    /* 初始化流布局视图 */
    _collectionView                 = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
    _collectionView.dataSource      = self;
    _collectionView.delegate        = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
    
    /* 提前注册流布局item */
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}


#pragma mark -------------> UICollectionView协议方法
/**
 *  自定义流布局item个数 要比数据源的个数多1 需要一个作为清除历史记录的行
 *
 *  @param collectionView 当前流布局视图
 *  @param section        nil
 *
 *  @return 自定义流布局item的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count + 1;
}


/**
 *  第index项的item的size大小
 *
 *  @param collectionView       当前流布局视图
 *  @param collectionViewLayout nil
 *  @param indexPath            item索引
 *
 *  @return size大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _dataArr.count) {
        return CGSizeMake(self.frame.size.width, 40);
    }
    
    NSString *str      = _dataArr[indexPath.row];
    /* 根据每一项的字符串确定每一项的size */
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize size        = [str boundingRectWithSize:CGSizeMake(self.frame.size.width, 1000) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil].size;
    size.height        = 25;
    size.width         += 15;
    return size;
    
}

/**
 *  流布局的边界距离 上下左右
 *
 *
 *
 *  @return 边界距离值
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(3, 5, 3, 3);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *vie in cell.contentView.subviews) {
        [vie removeFromSuperview];
    }
    if (indexPath.row == _dataArr.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        label.text = (_dataArr.count==0?(@"暂无历史记录"):(@"清除历史记录"));
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        return cell;
    }
    NSString *str                       = _dataArr[indexPath.row];
    NSDictionary *dict                  = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize size                         = [str boundingRectWithSize:CGSizeMake(self.frame.size.width, 1000) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil].size;
    UILabel *label                      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 40)];
    label.text                          = str;
    label.textColor = [UIColor grayColor];
    label.font                          = [UIFont systemFontOfSize:16];
    cell.contentView.layer.cornerRadius = 8;
    cell.contentView.clipsToBounds      = YES;
    cell.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    label.layer.borderColor             = [UIColor whiteColor].CGColor;
    [cell.contentView addSubview:label];
    label.center                        = cell.contentView.center;
    return cell;
}



/**
 *  当前点击的item的响应方法
 *
 *  @param collectionView 当前流布局
 *  @param indexPath      索引
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    /* 响应回调block */
    //    NSLog(@"%ld",(long)indexPath.row);
    _itemClick(indexPath.row);
//    self.searchVC
    [self.searchVC oo:indexPath];
    
}

- (void)refresh{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    [_collectionView reloadData];
    //    });
    
}

@end
