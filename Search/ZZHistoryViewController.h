//
//  ZZHistoryViewController.h
//  Search
//
//  Created by zz on 16/7/13.
//  Copyright © 2016年 zhcz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
typedef void (^itemClickBlock)(NSInteger i);;
@interface ZZHistoryViewController : UIView
@property(strong,nonatomic)FirstViewController*searchVC;
@property (copy, nonatomic) itemClickBlock itemClick;   //Item点击事件的回调block


//初始化方法
- (id)initWithFrame:(CGRect)frame
           andItems:(NSArray *)items
  andItemClickBlock:(itemClickBlock)click;

- (void)refresh;
@end
