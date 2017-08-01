//
//  SLCityListViewController.h
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLCityModel.h"

@protocol SLCityListViewControllerDelegate <NSObject>

- (void)sl_cityListSelectedCity:(NSString *)selectedCity Id:(NSInteger)Id;

@end

@interface SLCityListViewController : UIViewController
/** 城市model */
@property (strong, nonatomic) SLCityModel *cityModel;


/** 代理 */
@property (weak, nonatomic) id<SLCityListViewControllerDelegate> delegate;



@end
