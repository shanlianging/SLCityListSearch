//
//  SLLocationHelp.h
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^LocationPlacemark)(CLPlacemark *placemark);
typedef void(^LocationFailed)(NSError *error);
typedef void(^LocationStatus)(CLAuthorizationStatus status);



@interface SLLocationHelp : NSObject





+ (instancetype)sharedInstance;



- (void)getLocationPlacemark:(LocationPlacemark)placemark status:(LocationStatus)status didFailWithError:(LocationFailed)error;



@end
