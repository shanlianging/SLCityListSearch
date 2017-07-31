//
//  SLHotCityCell.h
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLCityModel;

@interface SLHotCityCell : UITableViewCell


/** 热门城市点击 */
@property (strong, nonatomic) RACSubject *hotCitySubject;

///** 选择城市 */
//@property (strong, nonatomic) NSString *locationCity;

/**  */
@property (strong, nonatomic) SLCityModel *cityModel;


@end
