//
//  ViewController.m
//  频道添加、排序、删除
//
//  Created by 天Ming是个小可爱 on 2017/1/4.
//  Copyright © 2017年 天Ming是个小可爱. All rights reserved.
//

#import "ViewController.h"
#import "ListViewController.h"
#import "TopicViewController.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width

#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

#define TitlesButtonW SCREEN_WIDTH / 6

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong)NSMutableArray *titleArray;

@property (nonatomic , strong)UIButton *selectBtn;

@property (nonatomic, strong)UIScrollView *titleScr;

@property (nonatomic, strong)UIScrollView *contentScr;

@end

@implementation ViewController
- (NSMutableArray *)titleArray
{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray arrayWithObjects:@"推荐",@"头条",@"热点",@"军事",@"娱乐",@"明星",@"电影",@"体育",@"段子", nil];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 添加子控制器
    [self setUpChildViewController];
    
    // 初始化设置标题栏
    [self setUpUI];
}
- (void)setUpUI{

    // 标题栏添加
    UIScrollView *titleScr = [[UIScrollView alloc] init];
    
    titleScr.showsHorizontalScrollIndicator = NO;
    
    titleScr.showsVerticalScrollIndicator = NO;
    
    self.titleScr = titleScr;
    
    titleScr.frame = CGRectMake(0, 64, SCREEN_WIDTH - TitlesButtonW, 45);
    
    titleScr.backgroundColor = [UIColor brownColor];
    
    NSInteger i = self.childViewControllers.count;
    
    titleScr.contentSize = CGSizeMake(i * TitlesButtonW, 0);
    
    [self.view addSubview:titleScr];
    
    // 设置标题按钮
    [self setUpTitleButtons];
    
    // 设置内容部分
    [self setupContentScrollView];
    
    [self addBtn];
}
- (void)setUpTitleButtons
{
    for (NSInteger i = 0; i< self.childViewControllers.count; i++)
    {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        
        titleButton.tag = i;
        
        titleButton.frame = CGRectMake(i * TitlesButtonW, 0, TitlesButtonW, 45);
        
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        TopicViewController *vc = self.childViewControllers[i];
        
        //文字
        [titleButton setTitle:vc.titleName forState:UIControlStateNormal];
        
        [titleButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        [self.titleScr addSubview:titleButton];
        
        if (i == 0)
        {
            [self titleButtonClick:titleButton];
        }
    }
}
- (void)setupContentScrollView
{
    UIScrollView *contentScr = [[UIScrollView alloc] init];
    
    self.contentScr = contentScr;
    
    contentScr.frame = CGRectMake(0, 45 + 64, SCREEN_WIDTH, SCREENH_HEIGHT - 64 - 45);
    
    contentScr.backgroundColor = [UIColor brownColor];
    
    contentScr.pagingEnabled = YES;
    
    contentScr.delegate = self;
    
    [self.view addSubview:contentScr];
    
    // 添加子控制器的view
    NSInteger count = self.childViewControllers.count;
    
    contentScr.contentSize = CGSizeMake(count * SCREEN_WIDTH, 0);
}
- (void)setUpChildViewController{
    
    for (NSString *name in self.titleArray)
    {
        TopicViewController *tp = [[TopicViewController alloc] init];
        
        tp.titleName = name;
        
        [self addChildViewController:tp];
    }
}
- (void)addBtn{
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    changeBtn.frame = CGRectMake(SCREEN_WIDTH - TitlesButtonW, 64, TitlesButtonW, 45);
    
    [changeBtn setTitle:@"点我" forState:UIControlStateNormal];
    
    [changeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [changeBtn addTarget:self action:@selector(loadChannel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:changeBtn];
}
#pragma mark - 点击事件
- (void)loadChannel
{
    // 加载频道处理列表
    ListViewController *listView = [[ListViewController alloc] init];
    
    listView.myChannelData = self.titleArray;
    
    [self presentViewController:listView animated:YES completion:nil];
    
}
- (void)titleButtonClick:(UIButton *)btn
{
    self.selectBtn.selected = NO;
    
    btn.selected = YES;
    
    self.selectBtn = btn;
    
    NSInteger index = btn.tag;
    
    TopicViewController *vc = self.childViewControllers[index];
    
    self.title = vc.titleName;
  
    [UIView animateWithDuration:0.25 animations:^{
        
        //处理视图滚动
        CGFloat offsetX = SCREEN_WIDTH * index;
        
        self.contentScr.contentOffset = CGPointMake(offsetX, 0);
        
    }completion:^(BOOL finished) {
        
        //懒加载控制器的view
        [self addChildVcViewIntoScrollView:index];
    }];
    
    // 让标题居中
    [self setUpTitleLabelCenter:btn];
}
/**
 *  添加第index个子控制器的view到scrollView中
 */
-(void)addChildVcViewIntoScrollView:(NSInteger)index
{
    UITableViewController *childVc = self.childViewControllers[index];
    
    if (childVc.isViewLoaded) return;
    
    UIView *view = childVc.view;
    
    view.frame = self.contentScr.bounds;
    
    [self.contentScr addSubview:view];
}
- (void)setUpTitleLabelCenter:(UIButton *)selectBtn
{
    if (self.childViewControllers.count * TitlesButtonW <= self.contentScr.bounds.size.width) return;
    
    // 计算偏移量
    CGFloat offsetX = selectBtn.center.x - self.contentScr.bounds.size.width * 0.5;
    
    if (offsetX < 0) offsetX = 0;
    
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.titleScr.contentSize.width - self.contentScr.bounds.size.width + TitlesButtonW;
    
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    
    [self.titleScr setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    UIButton *titleBtn = self.titleScr.subviews[index];
    
    [self titleButtonClick:titleBtn];
}
@end
