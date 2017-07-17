//
//  SLCityModel.h
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SLCity;
@class SLCityList;


@interface SLCityModel : NSObject


/** 热门城市 */
@property (strong, nonatomic) NSArray<SLCity *> *hotCity;
/** 城市列表 */
@property (strong, nonatomic) NSArray<SLCityList *> *list;

/** 选中城市 */
@property (strong, nonatomic) NSString *selectedCity;

/** 选中城市ID */
@property (assign, nonatomic) NSInteger selectedCityId;

/** 高度 */
@property (assign, nonatomic) CGFloat hotCellH;

@end


@interface SLCityList : NSObject

/** 城市数组 */
@property (strong, nonatomic) NSArray<SLCity *> *citys;

/** 首字母 */
@property (strong, nonatomic) NSString *initial;



@end

@interface SLCity : NSObject


/** 城市 */
@property (strong, nonatomic) NSString *name;
/** ID */
@property (assign, nonatomic) NSInteger Id;

/** 是否被选中 */
@property (assign, nonatomic, getter=isSelected) BOOL selected;




@end
