//
//  ChannelView.h
//  频道添加、排序、删除
//
//  Created by 天Ming是个小可爱 on 2017/1/9.
//  Copyright © 2017年 天Ming是个小可爱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIImageView *delBtn;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

+ (instancetype)creatChannelView;

@end
