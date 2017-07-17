//
//  SLLocationHelp.h
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^Location)(NSString *location);
typedef void(^NoLaction)();
typedef void(^LocationPlacemark)(CLPlacemark *placemark);
typedef void(^LocationFailed)(NSError *error);
typedef void(^LocationStatus)(CLAuthorizationStatus status);



@interface SLLocationHelp : NSObject

/** 定位 */
@property(strong,nonatomic)Location location;

/** 所有定位信息 */
@property (copy, nonatomic) LocationPlacemark locationPlacemark;
/** 没有定位 */
@property (copy, nonatomic) NoLaction noLocation;

/** 定位失败 */
@property (copy, nonatomic) LocationFailed locationFailed;
/** 定位状态 */
@property (copy, nonatomic) LocationStatus locationStatus;


+ (instancetype)sharedInstance;

-(void)getLocation:(NoLaction)location;

- (void)getLocationPlacemark:(LocationPlacemark)placemark noLocation:(NoLaction)noLocation;

- (void)getLocationPlacemark:(LocationPlacemark)placemark status:(LocationStatus)status didFailWithError:(LocationFailed)error;



@end
