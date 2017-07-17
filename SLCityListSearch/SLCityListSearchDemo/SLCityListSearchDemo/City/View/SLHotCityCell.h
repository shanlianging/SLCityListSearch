//
//  SLHotCityCell.h
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLCity;

@interface SLHotCityCell : UITableViewCell

/** 热门城市数组 */
@property (strong, nonatomic) NSArray<SLCity *> *hotArray;

/** 热门城市点击 */
@property (strong, nonatomic) RACSubject *hotCitySubject;

/** 选择城市 */
@property (strong, nonatomic) NSString *locationCity;


@end
