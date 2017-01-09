//
//  ChannelView.m
//  频道添加、排序、删除
//
//  Created by 天Ming是个小可爱 on 2017/1/9.
//  Copyright © 2017年 天Ming是个小可爱. All rights reserved.
//

#import "ChannelView.h"
@interface ChannelView ()



@end

@implementation ChannelView

+ (instancetype)creatChannelView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ChannelView class]) owner:nil options:nil].firstObject;
}
@end
