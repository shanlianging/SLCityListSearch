//
//  SLCityLocationView.h
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLCityLocationView : UIView


+ (instancetype)cityLocationView;


/** 定位城市 */
@property (strong, nonatomic) UIButton *cityButton;
/** 重新定位按钮 */
@property (strong, nonatomic) UIButton *locationButton;

/** 定位城市 */
@property (strong, nonatomic) NSString *locationCity;

@end
