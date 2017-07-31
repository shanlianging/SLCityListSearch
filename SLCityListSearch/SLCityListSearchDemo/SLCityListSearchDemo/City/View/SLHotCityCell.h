//
//  SLHotCityCell.h
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLCityModel;


typedef void(^SelectedCityBlock)(NSString *selectedCity, NSInteger Id);

@interface SLHotCityCell : UITableViewCell

/** 城市模型 */
@property (strong, nonatomic) SLCityModel *cityModel;
/** 城市选择block */
@property (copy, nonatomic) SelectedCityBlock selectedCityBlock;


@end
