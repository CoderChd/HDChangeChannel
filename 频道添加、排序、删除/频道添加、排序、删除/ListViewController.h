//
//  ListViewController.h
//  频道添加、排序、删除
//
//  Created by 天Ming是个小可爱 on 2017/1/5.
//  Copyright © 2017年 天Ming是个小可爱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController

/** 我的频道 */
@property (nonatomic, strong)NSMutableArray *myChannelData;

/** 频道推荐 */
@property (nonatomic, strong)NSMutableArray *channelRecommend;

@end
