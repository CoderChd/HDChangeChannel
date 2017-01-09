//
//  ViewController.m
//  频道添加、排序、删除
//
//  Created by 天Ming是个小可爱 on 2017/1/4.
//  Copyright © 2017年 天Ming是个小可爱. All rights reserved.
//

#import "ViewController.h"
//#import "ListViewController.h"
#import "TopicViewController.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width

#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

#define TitlesButtonW SCREEN_WIDTH / 6

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong)NSArray *titleArray;

@property (nonatomic , strong)UIButton *selectBtn;

@property (nonatomic, strong)UIScrollView *titleScr;

@property (nonatomic, strong)UIScrollView *contentScr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.titleArray = @[@"推荐",@"头条",@"热点",@"军事",@"娱乐",@"明星",@"电影",@"体育",@"段子"];
    
    // 添加子控制器
    [self setUpChildViewController];
    
    // 初始化设置标题栏
    [self setUpUI];
}
- (void)setUpUI{

    UIScrollView *titleScr = [[UIScrollView alloc] init];
    
    titleScr.showsHorizontalScrollIndicator = NO;
    
    titleScr.showsVerticalScrollIndicator = NO;
    
    self.titleScr = titleScr;
    
    titleScr.frame = CGRectMake(0, 64, SCREEN_WIDTH, 45);
    
    titleScr.backgroundColor = [UIColor brownColor];
    
    NSInteger i = self.childViewControllers.count;
    
    titleScr.contentSize = CGSizeMake(i * TitlesButtonW, 0);
    
    [self.view addSubview:titleScr];
    
    // 设置标题按钮
    [self setUpTitleButtons];
    
    // 设置内容部分
    [self setupContentScrollView];
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
#pragma mark - 点击事件
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
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    UIButton *titleBtn = self.titleScr.subviews[index];
    
    [self titleButtonClick:titleBtn];
}
@end
