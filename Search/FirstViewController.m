//
//  FirstViewController.m
//  Search
//
//  Created by zz on 16/7/13.
//  Copyright © 2016年 zhcz. All rights reserved.
//

#import "FirstViewController.h"
#import "NextViewController.h"
#import "ZZHistoryViewController.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface FirstViewController ()<UITextFieldDelegate>
@property(strong,nonatomic)UITextField * searchT;//搜索

@property(strong,nonatomic)UIButton * goodsBt;
@property(strong,nonatomic)UIButton * shopBt;
@property(strong,nonatomic)UIButton * selectBt;

@property(assign,nonatomic)BOOL isSelect;
@property(strong,nonatomic)UIView * backView;
@property(strong,nonatomic)UIView * blackView;

@property(strong,nonatomic)UIImageView * goodsImageV;
@property(strong,nonatomic)UIImageView * shopImageV;

@property(strong,nonatomic)NSNumber * type;
@property(strong,nonatomic)NSMutableArray * searchOfHistoryArr;
@property(strong,nonatomic)NSMutableArray * dataArr;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupView];
}

- (void)setupView
{
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView * navigationBarV = [[UIView alloc]init];
    navigationBarV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    navigationBarV.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:140.0/255.0 blue:253.0/255.0 alpha:1];
    [self.view addSubview:navigationBarV];
    
    
    _searchT = [[UITextField alloc]init];
    _searchT.frame = CGRectMake(60, 25, SCREEN_WIDTH-120, 30 );
    _searchT.layer.cornerRadius = 5;
    _searchT.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchT.delegate = self;
    _searchT.backgroundColor = [UIColor whiteColor];
    _searchT.placeholder = @"搜索商家或商品";
    [_searchT setValue:[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:218.0/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_searchT setValue:[UIFont fontWithName:@"Helvetica" size:16] forKeyPath:@"_placeholderLabel.font"];
    _searchT.delegate = self;
    [navigationBarV addSubview:_searchT];
    
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 74 , 30 )];
    leftView1.backgroundColor = _searchT.backgroundColor;
    _searchT.leftView = leftView1;
    _searchT.leftViewMode = UITextFieldViewModeAlways;
    
    _selectBt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _selectBt.frame = CGRectMake(0, 0, 44 , 30 );
    //    [_selectBt setTitle:@"商品" forState:(UIControlStateNormal)];
    //    [_selectBt setImage:[UIImage imageNamed:@"三角"] forState:(UIControlStateNormal)];
    _selectBt.backgroundColor = [UIColor redColor];
    [_selectBt setTitle:@"商品" forState:(UIControlStateNormal)];
    [_selectBt setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [_selectBt addTarget:self action:@selector(selectActon) forControlEvents:(UIControlEventTouchUpInside)];
    _selectBt.titleLabel.font = [UIFont systemFontOfSize:16 ];
    _selectBt.backgroundColor = [UIColor whiteColor];
    [leftView1 addSubview:_selectBt];
    
    UIImageView * downImageV = [[UIImageView alloc]init];
    downImageV.frame = CGRectMake(44 , 10 , 15 , 8 );
    downImageV.image = [UIImage imageNamed:@"三角"];
    downImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectActon)];
    [downImageV addGestureRecognizer:singleTap];
    [leftView1 addSubview:downImageV];
    
    _blackView = [[UIView alloc]init];
    _blackView.frame = self.view.bounds;
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.5;
    _blackView.hidden = YES;
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectActon)];
    [_blackView addGestureRecognizer:tap];
    [[[UIApplication sharedApplication]keyWindow] addSubview:_blackView];
    //    [self.view addSubview:_blackView];
    
    _backView = [[UIView alloc]init];
    _backView.layer.cornerRadius = 3;
    _backView.frame = CGRectMake(60 , CGRectGetMaxY(_searchT.frame), 0, 0);
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.8;
    self.isSelect = NO;
    [[[UIApplication sharedApplication]keyWindow] addSubview:_backView];
    //    [self.view addSubview:_backView];
    
    self.goodsBt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.goodsBt.frame = CGRectMake(20 , 0, 0, 0);
    [self.goodsBt addTarget:self action:@selector(goodsClicked) forControlEvents:(UIControlEventTouchUpInside)];
    [self.goodsBt setTitle:@"商品" forState:(UIControlStateNormal)];
    //    [self.goodsBt setImage:[UIImage imageNamed:@"商品"] forState:(UIControlStateNormal)];
    [self.goodsBt setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.goodsBt.titleLabel.font  =[UIFont systemFontOfSize:16 ];
    [_backView addSubview:self.goodsBt];
    
    _goodsImageV = [[UIImageView alloc]init];
    _goodsImageV.image = [UIImage imageNamed:@"商品"];
    _goodsImageV.frame = CGRectMake(10 , 7 , 15 , 0);
    [_backView addSubview:_goodsImageV];
    
    
    self.shopBt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.shopBt.frame = CGRectMake(20 , 30 , 0, 0);
    [self.shopBt addTarget:self action:@selector(shopClicked) forControlEvents:(UIControlEventTouchUpInside)];
    //    [self.shopBt setImage:[UIImage imageNamed:@"商铺"] forState:(UIControlStateNormal)];
    [self.shopBt setTitle:@"店铺" forState:(UIControlStateNormal)];
    [self.shopBt setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.shopBt.titleLabel.font  =[UIFont systemFontOfSize:16 ];
    [_backView addSubview:self.shopBt];
    
    _shopImageV = [[UIImageView alloc]init];
    _shopImageV.image = [UIImage imageNamed:@"商铺"];
    _shopImageV.frame = CGRectMake(10 , 37 , 15 , 0);
    [_backView addSubview:_shopImageV];
    
    
    
    UIButton * searchButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchButton.frame = CGRectMake(SCREEN_WIDTH-45 , 20, 35 , 35 );
    [searchButton setTitle:@"搜索" forState:(UIControlStateNormal)];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:16 ];
    [searchButton addTarget:self action:@selector(searchClicked) forControlEvents:(UIControlEventTouchUpInside)];
    [searchButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [navigationBarV addSubview:searchButton];
    
    
    
    
    //    进入搜索页面默认是商品
    self.type = @1;
    _searchOfHistoryArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    
}
- (void)clearClicked
{
    NSLog(@"clear");
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [document stringByAppendingPathComponent:@"searchOfHistory"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:path error:nil];
    
    
    [self.dataArr removeAllObjects];
    [self setupView];
    //    [self.history refresh];
    [self loadHistoryView];
    
    
}
- (void)oo:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArr.count) {
        [self clearClicked];
    }else{
        NSLog(@"row====%ld",(long)indexPath.row);
        NextViewController * sVC = [[NextViewController alloc]init];
        sVC.type = self.dataArr[indexPath.row][@"type"];
        sVC.name = self.dataArr[indexPath.row][@"name"];
        sVC.flag = 1;
        [self.navigationController pushViewController:sVC animated:YES];
    }
}



- (void)goodsClicked
{
    self.type = @1;
    [self.selectBt setTitle:@"商品" forState:(UIControlStateNormal)];
    [self selectActon];
}
- (void)shopClicked
{
    self.type = @0;
    [self.selectBt setTitle:@"店铺" forState:(UIControlStateNormal)];
    [self selectActon];
}
- (void)selectActon
{
    NSLog(@"xuanze");
    if (self.isSelect == NO) {
        [UIView animateWithDuration:0.2 animations:^{
            _blackView.hidden = NO;
            _backView.frame = CGRectMake(60, CGRectGetMaxY(_searchT.frame), 100, 80);
            self.goodsBt.frame = CGRectMake(20, 0, 80, 40);
            _goodsImageV.frame = CGRectMake(10, 10, 20, 20);
            self.shopBt.frame = CGRectMake(20, 30, 80, 40);
            _shopImageV.frame = CGRectMake(10, 40, 20, 20);
            
            self.isSelect = YES;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            _blackView.hidden = YES;
            _backView.frame = CGRectMake(60, CGRectGetMaxY(_searchT.frame), 0, 0);
            self.goodsBt.frame = CGRectMake(30, 0, 0, 0);
            _goodsImageV.frame = CGRectMake(10, 10, 0, 0);
            self.shopBt.frame = CGRectMake(20, 30, 0, 0);
            _shopImageV.frame = CGRectMake(10, 40, 0, 0);
            self.isSelect = NO;
        }];
    }
}
- (void)searchClicked
{
    if ([_searchT.text isEqualToString:@""]) {
        //        [SVProgressHUD showErrorWithStatus:@"请输入要搜索的内容！"];
    }else{
        NextViewController * sVC = [[NextViewController alloc]init];
        sVC.type = self.type;
        sVC.name = self.searchT.text;
        
        sVC.flag = 1;
        [self.navigationController pushViewController:sVC animated:YES];
        //保存数据到本地
        NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filename = [Path stringByAppendingPathComponent:@"searchOfHistory"];
        NSMutableArray * arr =  [NSMutableArray arrayWithContentsOfFile:filename];
        if (arr) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setValue:self.searchT.text forKey:@"name"];
            [dic setValue:self.type forKey:@"type"];
            [arr addObject:dic];
            NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
//            将数组中重复的数控剔除
            for (unsigned i = 0; i < [arr count]; i++){
                if ([categoryArray containsObject:[arr objectAtIndex:i]] == NO){
                    [categoryArray addObject:[arr objectAtIndex:i]];
                }
            }
            [categoryArray writeToFile:filename atomically:YES];
        }else{
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            _searchOfHistoryArr = [NSMutableArray array];
            [dic setValue:self.searchT.text forKey:@"name"];
            [dic setValue:self.type forKey:@"type"];
            [_searchOfHistoryArr addObject:dic];
            [_searchOfHistoryArr writeToFile:filename atomically:YES];
        }
    }
}
- (void)viewDidAppear:(BOOL)animated{
    //加载数据
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"searchOfHistory"];
    self.dataArr =   [NSMutableArray arrayWithContentsOfFile:filename];
    self.dataArr = (NSMutableArray*)[[self.dataArr reverseObjectEnumerator]allObjects];
    [self loadHistoryView];
    
}
//加载历史记录视图
- (void)loadHistoryView
{
    NSMutableArray * arr = [NSMutableArray array];
    for (NSDictionary * dic in self.dataArr) {
        [arr addObject:dic[@"name"]];
    }
    /*        添加自定义视图         */
    ZZHistoryViewController *history = [[ZZHistoryViewController alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 250) andItems:arr andItemClickBlock:^(NSInteger i) {
        
        /*        相应点击事件 i为点击的索引值         */
    }];
    history.searchVC = self;
    [self.view addSubview:history];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchT resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchClicked];
    return YES;
}
// 隐藏tabbar
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
}

@end


