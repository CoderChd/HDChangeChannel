//
//  ListViewController.m
//  频道添加、排序、删除
//
//  Created by 天Ming是个小可爱 on 2017/1/5.
//  Copyright © 2017年 天Ming是个小可爱. All rights reserved.
//

#import "ListViewController.h"
#import "ChannelView.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width

#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

/** 没行频道的个数 */
#define ButtonRow 4

/** 边距 */
#define margin 5

/** 按钮的宽度 */
#define ButtonW (SCREEN_WIDTH - 2 * margin)/ButtonRow

/** 按钮的高度 */
#define ButtonH ButtonW * 4/9

@interface ListViewController ()

/** 我的频道视图 */
@property (nonatomic, strong)UIView *topContentView;

/** 推荐频道视图 */
@property (nonatomic, strong)UIView *bottomContentView;

/**  */
@property (nonatomic, strong)UIScrollView *contentView;

/** 编辑按钮 */
@property (nonatomic, strong)UIButton *edit;

/** 当前移动的视图index */
@property (nonatomic, assign)NSInteger moveIndex;

/** 保存我的频道所有视图 */
@property (nonatomic, strong)NSMutableArray <ChannelView *> *myChannelView;

/** 保存推荐频道所有视图 */
@property (nonatomic, strong)NSMutableArray <ChannelView *> *recommendChannelView;

@property (nonatomic, strong) ChannelView *clearView;

@property (nonatomic, assign,getter=isEditing)BOOL editing;

@property (nonatomic, strong)UIPanGestureRecognizer *pan;

@property (nonatomic, strong)UILongPressGestureRecognizer *longPress;

@property (nonatomic, strong)UITapGestureRecognizer *tap;

@end

@implementation ListViewController

#pragma mark - 搭建界面
- (NSMutableArray<ChannelView *> *)myChannelView
{
    if (_myChannelView == nil) {
        _myChannelView = [NSMutableArray arrayWithCapacity:1];
    }
    return _myChannelView;
}
- (NSMutableArray<ChannelView *> *)recommendChannelView
{
    if (_recommendChannelView == nil) {
        _recommendChannelView = [NSMutableArray arrayWithCapacity:1];
    }
    return _recommendChannelView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpScrollView];
    
    // 设置导航条
    [self setUpNav];
    
    // 设置我的频道
    [self setUpMyChannel];
}
- (void)setUpScrollView
{
    UIScrollView *contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    self.contentView = contentView;
    
    contentView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:contentView];
}
- (void)setUpNav
{
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}
- (void)setUpMyChannel
{
    // 添加头部 - 我的频道
    [self addTopContentView];
    
    // 添加编辑按钮
    [self addEditBtn];
    
    // 设置每个频道View
    [self addChannelView];
    
    // 添加底部 - 频道推荐
    [self addBottomContent];
}
#pragma mark - 点击事件、手势处理
- (void)editClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self enterEditStatue];
    }else
    {
        [self quitEditStatue];
    }
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)topPanAct:(UIPanGestureRecognizer *)pan
{
    if (self.isEditing) { // 处于编辑状态
        
        [self delSlideWithGesture:pan];
    }
}
-(void)topTapAct:(UITapGestureRecognizer *)tap{
    // 处于编辑状态就是删除频道
    if (self.isEditing) {
         ChannelView *channel = (ChannelView *)tap.view;
        
        [self.myChannelView removeObject:channel];
        
        [channel removeFromSuperview];
        
        [self refreshTopView];
    }
}
-(void)longTapAct:(UILongPressGestureRecognizer *)longPress
{
    [self delSlideWithGesture:longPress];
}
- (void)delSlideWithGesture:(UIGestureRecognizer *)gesture
{
     ChannelView *channel = (ChannelView *)gesture.view;
    
    [self.contentView bringSubviewToFront:self.topContentView];
    
    [self.topContentView bringSubviewToFront:channel];
    
    static CGPoint touchPoint;
    static CGFloat offsetX;
    static CGFloat offsetY;
    static NSInteger staticIndex = 0;
    
    static CGPoint oldCenter;
    
    if (gesture.state == UIGestureRecognizerStateBegan)// 确认为长按状态
    {
        // 进入编辑状态
        [self enterEditStatue];
        
        //初始手指长按的位置
        touchPoint = [gesture locationInView:channel];
        
        CGPoint centerPoint = CGPointMake(ButtonW/2, ButtonH/2);
        
        offsetX = touchPoint.x - centerPoint.x;
        
        offsetY = touchPoint.y - centerPoint.y;
        
        // 记录当前的坐标，为结束拖动做准备
        oldCenter = channel.center;
        
        // 从数组中移除当前正在拖动的视图
        [self.myChannelView removeObject:channel];
        
        self.moveIndex = [self.myChannelView indexOfObject:channel];
        
    }else if (gesture.state == UIGestureRecognizerStateChanged) // 长按状态下移动
    {
        CGPoint movePoint = [gesture locationInView:self.topContentView];
        
        channel.center = CGPointMake(movePoint.x - offsetX, movePoint.y - offsetY);
        
        CGFloat x = channel.center.x;
        
        CGFloat y = channel.center.y;
        
        if (y >= 0 && y <= self.topContentView.frame.size.height && x >= 0 && x <= self.topContentView.frame.size.width){   // 范围之内
            
            // 记录移动过程中该视图目前所处的index
            int index = (int)(y / (ButtonH + margin)) * ButtonRow + (int)(x / (ButtonW + margin));
            
            if (staticIndex != index) {
                
                staticIndex = index;
                
                if (staticIndex < self.myChannelView.count && staticIndex >= 0) {
                    
                    if ([self.myChannelView containsObject:self.clearView]) {
                        [self.myChannelView removeObject:self.clearView];
                    }
                    [self.myChannelView insertObject:self.clearView atIndex:staticIndex];
                    
                    self.clearView.frame = CGRectMake(margin + staticIndex%ButtonRow*ButtonW, staticIndex/ButtonRow * ButtonH + margin, ButtonW, ButtonH);
                    
                    [self refreshTopView];
                }
            }
        }
    }else if(gesture.state == UIGestureRecognizerStateEnded){ // 长按后松开
        
        CGFloat x = channel.center.x;
        CGFloat y = channel.center.y;
        
        // 判断是否在范围内
        if (y >= 0 && y <= self.topContentView.frame.size.height && x >= 0 && x <= self.topContentView.frame.size.width){  // 范围内
            
            self.moveIndex = (int)(y / (ButtonH + margin)) * ButtonRow + (int)(x / (ButtonW + margin));
        }
        if ([self.myChannelView containsObject:self.clearView]) {
            [self.myChannelView removeObject:self.clearView];
        }
        
        // 处理超出最大index的情况
        if (_moveIndex < self.myChannelView.count && _moveIndex >= 0){
            [self.myChannelView insertObject:channel atIndex:_moveIndex];
        }else
        {
            [self.myChannelView addObject:channel]; // 直接放到最后一个
        }
        
        [self refreshTopView];
        
        // 初始化一下
        staticIndex = 0;
    }
}
#pragma mark - 处理逻辑的一些方法
- (void)addTopContentView
{
    UIView *topContentView = [[UIView alloc] init];
    
    topContentView.backgroundColor = [UIColor greenColor];
    
    self.topContentView = topContentView;
    
    topContentView.frame = CGRectMake(0, 40, SCREEN_WIDTH, 150);
    
    [self.contentView addSubview:topContentView];
}
- (void)addEditBtn
{
    UIButton *edit = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.edit = edit;
    
    edit.backgroundColor = [UIColor grayColor];
    
    [edit setTitle:@"编辑" forState:UIControlStateNormal];
    
    [edit setTitle:@"完成" forState:UIControlStateSelected];
    
    [edit setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [edit addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    
    edit.frame = CGRectMake(SCREEN_WIDTH - 62, margin, 50, 20);
    
    [self.contentView addSubview:edit];
}
- (void)addChannelView
{
    // 添加频道列表
    for (int i = 0; i < self.myChannelData.count; i++) {
        
        ChannelView *channel = [ChannelView creatChannelView];
        
        channel.frame = CGRectMake(5 + i % ButtonRow * ButtonW, i/ButtonRow * ButtonH + margin, ButtonW, ButtonH);
        
        channel.delBtn.hidden = YES;
        
        channel.titleName.text = self.myChannelData[i];
        
        [self.topContentView addSubview:channel];
        
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topTapAct:)];
        
        [channel addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(topPanAct:)];
        
        self.pan = pan;
        
        [channel addGestureRecognizer:pan];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAct:)];
        
        self.longPress = longPress;
        
        [channel addGestureRecognizer:longPress];
        
        [self.myChannelView addObject:channel];
    }
}
- (void)addBottomContent
{
    UIView *bottomView = [[UIView alloc] init];
    
    self.bottomContentView = bottomView;
    
    bottomView.backgroundColor = [UIColor orangeColor];
    
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.topContentView.frame) + 60, SCREEN_WIDTH, 300);
    
    [self.contentView addSubview:bottomView];
    
    // 添加推荐频道列表
    for (int i = 0; i < self.channelRecommend.count; i++) {
        
        ChannelView *channel = [ChannelView creatChannelView];
        
        channel.frame = CGRectMake(5 + i % ButtonRow * ButtonW, i/ButtonRow * ButtonH + margin, ButtonW, ButtonH);
        
        channel.delBtn.hidden = YES;
        
        channel.titleName.text = self.channelRecommend[i];
        
        [bottomView addSubview:channel];
        
        [self.recommendChannelView addObject:channel];
    }
}
// 进入编辑状态
- (void)enterEditStatue
{
    self.editing = YES;
    
    for (int i = 0; i < self.myChannelData.count; i++) {
        
        ChannelView *touchView = self.topContentView.subviews[i];
        
        touchView.delBtn.hidden = NO;
    }
}
// 退出编辑状态
- (void)quitEditStatue
{
    self.editing = NO;
    
    for (int i = 0; i < self.myChannelData.count; i++) {
        
        ChannelView *touchView = self.topContentView.subviews[i];
        
        touchView.delBtn.hidden = YES;
    }
}
#pragma mark - 用于占位的透明label
- (ChannelView *)clearView
{
    if (_clearView == nil) {
        _clearView = [ChannelView creatChannelView];
        _clearView.backgroundColor = [UIColor redColor];
    }
    return _clearView;
}
#pragma mark - 重新布局
-(void)refreshTopView
{
    [UIView animateWithDuration:0.5 animations:^{
        for (int i = 0; i < self.myChannelView.count; ++i) {
            ChannelView *touchView = self.myChannelView[i];
            touchView.frame = CGRectMake(margin + i%ButtonRow * ButtonW, margin + i/ButtonRow*ButtonH, ButtonW, ButtonH);
        }
    }];
}
@end
