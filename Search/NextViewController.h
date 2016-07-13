//
//  NextViewController.h
//  Search
//
//  Created by zz on 16/7/13.
//  Copyright © 2016年 zhcz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NextViewController : UIViewController
@property (nonatomic,copy)NSString *cityCode;
@property(strong,nonatomic)NSString *userLng;
@property(strong,nonatomic)NSString *userLat;
@property (nonatomic,copy)void(^titleBlock)(NSString*);
@property(strong,nonatomic)NSNumber * type;
@property(strong,nonatomic)NSString*name;
@property(strong,nonatomic)UITextField * searchT;//搜索

@property(assign,nonatomic)NSInteger flag;
@end
