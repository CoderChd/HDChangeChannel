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

@interface ListViewController ()

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor brownColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(SCREEN_WIDTH - 80, 20, 50, 50);
    
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    // 设置我的频道
    [self setUpMyChannel];
}
- (void)setUpMyChannel
{
    for (int i = 0; i < self.myChannelData.count; i++) {
        ChannelView *btn = [ChannelView creatChannelView];
        
//        btn.frame = CGRectMake(5 + i * ButtonRow * , <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        
        btn.delBtn.hidden = YES;
        
    }
}
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
