//
//  NextViewController.m
//  Search
//
//  Created by zz on 16/7/13.
//  Copyright © 2016年 zhcz. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>
@property(nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic,retain)UIImageView *imageView;
@property(assign,nonatomic)BOOL isSelect;
@property(strong,nonatomic)UIView * backView;
@property(strong,nonatomic)UITableView * tableview;
@property(strong,nonatomic)UIButton * goodsBt;
@property(strong,nonatomic)UIButton * shopBt;
@property(strong,nonatomic)UIButton * selectBt;
@property(strong,nonatomic)UIImageView * goodsImageV;
@property(strong,nonatomic)UIImageView * shopImageV;
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    //    进入搜索页面默认是商品
    self.dataArray = [NSMutableArray array];
    //    [self searchClicked];
    [self getData];
    
}
- (void)setTableview:(UITableView *)tableview{
    _tableview = [[UITableView alloc]init];
    _tableview.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    UIView * view=[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableview setTableFooterView:view];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_tableview addGestureRecognizer:tableViewGesture];
    
    [self.view addSubview:_tableview];
}
- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [[NSMutableArray alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView * navigationBarV = [[UIView alloc]init];
    navigationBarV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    navigationBarV.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:140.0/255.0 blue:253.0/255.0 alpha:1];
    [self.view addSubview:navigationBarV];
    _searchT = [[UITextField alloc]init];
    _searchT.frame = CGRectMake(60, 25, SCREEN_WIDTH-120, 30);
    _searchT.layer.cornerRadius = 5;
    _searchT.text = self.name;
    _searchT.backgroundColor = [UIColor whiteColor];
    _searchT.placeholder = @"搜索商家或商品";
    [_searchT setValue:[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:218.0/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_searchT setValue:[UIFont fontWithName:@"Helvetica" size:16] forKeyPath:@"_placeholderLabel.font"];
    _searchT.delegate = self;
    [navigationBarV addSubview:_searchT];
    UIView *leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 74, 30)];
    leftView1.backgroundColor = _searchT.backgroundColor;
    _searchT.leftView = leftView1;
    _searchT.leftViewMode = UITextFieldViewModeAlways;
    
    _selectBt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _selectBt.frame = CGRectMake(0, 0, 44, 30);
    _selectBt.backgroundColor = [UIColor redColor];
    if (self.type.integerValue == 1) {
        [_selectBt setTitle:@"商品" forState:(UIControlStateNormal)];
    }else{
        [_selectBt setTitle:@"店铺" forState:(UIControlStateNormal)];
    }
    
    [_selectBt setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [_selectBt addTarget:self action:@selector(selectActon) forControlEvents:(UIControlEventTouchUpInside)];
    _selectBt.titleLabel.font = [UIFont systemFontOfSize:16];
    _selectBt.backgroundColor = [UIColor whiteColor];
    [leftView1 addSubview:_selectBt];
    
    UIImageView * downImageV = [[UIImageView alloc]init];
    downImageV.frame = CGRectMake(44, 10, 15, 8);
    downImageV.image = [UIImage imageNamed:@"三角"];
    downImageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectActon)];
    [downImageV addGestureRecognizer:singleTap];
    [leftView1 addSubview:downImageV];
    
    _backView = [[UIView alloc]init];
    _backView.layer.cornerRadius = 3;
    _backView.frame = CGRectMake(60, CGRectGetMaxY(_searchT.frame), 0, 0);
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.8;
    self.isSelect = NO;
    [self.view addSubview:_backView];
    
    self.goodsBt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.goodsBt.frame = CGRectMake(20, 0, 0, 0);
    [self.goodsBt addTarget:self action:@selector(goodsClicked) forControlEvents:(UIControlEventTouchUpInside)];
    [self.goodsBt setTitle:@"商品" forState:(UIControlStateNormal)];
    [self.goodsBt setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.goodsBt.titleLabel.font  =[UIFont systemFontOfSize:16];
    [_backView addSubview:self.goodsBt];
    
    _goodsImageV = [[UIImageView alloc]init];
    _goodsImageV.image = [UIImage imageNamed:@"商品"];
    _goodsImageV.frame = CGRectMake(10, 7, 15, 0);
    [_backView addSubview:_goodsImageV];
    
    self.shopBt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.shopBt.frame = CGRectMake(20, 30, 0, 0);
    [self.shopBt addTarget:self action:@selector(shopClicked) forControlEvents:(UIControlEventTouchUpInside)];
    [self.shopBt setTitle:@"店铺" forState:(UIControlStateNormal)];
    [self.shopBt setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.shopBt.titleLabel.font  =[UIFont systemFontOfSize:16];
    [_backView addSubview:self.shopBt];
    
    _shopImageV = [[UIImageView alloc]init];
    _shopImageV.image = [UIImage imageNamed:@"商铺"];
    _shopImageV.frame = CGRectMake(10, 37, 15, 0);
    [_backView addSubview:_shopImageV];
    
    UIButton * searchButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchButton.frame = CGRectMake(SCREEN_WIDTH-45, 20, 35, 35);
    [searchButton setTitle:@"搜索" forState:(UIControlStateNormal)];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [searchButton addTarget:self action:@selector(searchClicked) forControlEvents:(UIControlEventTouchUpInside)];
    [searchButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [navigationBarV addSubview:searchButton];
    
    //返回button
    UIButton * backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backButton.frame = CGRectMake(10, 20, 35, 35);
    [backButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:(UIControlStateNormal)];
    
    [navigationBarV addSubview:backButton];
}
- (void)commentTableViewTouchInSide{
    [self.searchT resignFirstResponder];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"type====%@",self.type);
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    将请求的数据展示在这里
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (self.isSelect == NO) {
        [UIView animateWithDuration:0.2 animations:^{
            
            _backView.frame = CGRectMake(60, CGRectGetMaxY(_searchT.frame), 100, 80);
            self.goodsBt.frame = CGRectMake(20, 0, 80, 40);
            _goodsImageV.frame = CGRectMake(10, 10, 20, 20);
            self.shopBt.frame = CGRectMake(20, 30, 80, 40);
            _shopImageV.frame = CGRectMake(10, 40, 20, 20);
            
            self.isSelect = YES;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
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
    [self getData];
    if (self.flag == 1) {
        //保存数据
        NSMutableArray * searchOfHistoryArr = [NSMutableArray array];
        NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filename = [Path stringByAppendingPathComponent:@"searchOfHistory"];
        NSMutableArray * arr =  [NSMutableArray arrayWithContentsOfFile:filename];
        if (arr) {
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setValue:self.searchT.text forKey:@"name"];
            [dic setValue:self.type forKey:@"type"];
            [arr addObject:dic];
            NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
            for (unsigned i = 0; i < [arr count]; i++){
                if ([categoryArray containsObject:[arr objectAtIndex:i]] == NO){
                    [categoryArray addObject:[arr objectAtIndex:i]];
                }
            }
            [categoryArray writeToFile:filename atomically:YES];
        }else{
            NSLog(@"gg");
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setValue:self.searchT.text forKey:@"name"];
            [dic setValue:self.type forKey:@"type"];
            [searchOfHistoryArr addObject:dic];
            [searchOfHistoryArr writeToFile:filename atomically:YES];
        }
    }
    
}

- (void)getData{
    
//    请求数据
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