//
//  SLCityModel.m
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import "SLCityModel.h"
#import "CityMacros.h"


@implementation SLCityModel


+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list": [SLCityList class], @"hotCity" : [SLCity class]};
}



@end

@implementation SLCityList

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"citys": [SLCity class]};
}

@end


@implementation SLCity

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"Id": @"id"};
}




@end
