//
//  SLLocationHelp.m
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import "SLLocationHelp.h"



@interface SLLocationHelp ()<CLLocationManagerDelegate>

// 定位管理器
@property (strong, nonatomic) CLLocationManager *manager;
// 地理编码和反编码
@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation SLLocationHelp

static id _instance = nil;
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        
    });
    return _instance;
}

-(void)getLocation:(NoLaction)location {
    
    [self locationAction];
    self.location =location;
    
}

- (void)getLocationPlacemark:(LocationPlacemark)placemark noLocation:(NoLaction)noLocation {
    
    if (placemark) {
        self.locationPlacemark = placemark;
    }
    
    if (noLocation) {
        self.noLocation = noLocation;
    }
    
    [self locationAction];
    
    
}


- (void)getLocationPlacemark:(LocationPlacemark)placemark status:(LocationStatus)status didFailWithError:(LocationFailed)error {
    
    if (placemark) {
        self.locationPlacemark = placemark;
    }
    
    if (status) {
        self.locationStatus = status;
    }
    
    if (error) {
        self.locationFailed = error;
    }
    
    
    
    
    [self locationAction];
    
    
}


- (void)locationAction {
    if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        if (self.noLocation) {
            self.noLocation();
        }

        
        
    }
    
    // 定位
    self.manager = [CLLocationManager new];
    self.manager.distanceFilter = 10;
    self.manager.desiredAccuracy = kCLLocationAccuracyKilometer;
    // 2.设置代理
    self.manager.delegate = self;
    
    // 3.请求定位
    //    if ([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    //        [self.manager requestAlwaysAuthorization];
    //    }
    //     只有使用时才访问位置信息
    if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.manager requestWhenInUseAuthorization];
    }
    
    // 4.开始定位
    [self.manager startUpdatingLocation];
    // 初始化编码器
    self.geocoder = [CLGeocoder new];
    
}





#pragma mark -- 地理位置代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = locations[0];
    // 通常为了节省电量和资源损耗，在获取到位置以后选择停止定位服务
    [self.manager stopUpdatingLocation];
    // 地理反编码
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placeMark = placemarks[0];
        
        
        NSString *locationName = [NSString stringWithFormat:@"%@-%@", placeMark.locality, placeMark.subLocality];
        
        if(self.location != nil)
        {
            self.location(locationName);
        }
        
        if (self.locationPlacemark) {
            self.locationPlacemark(placeMark);
        }
        
    }];
    
    
    
    
    
}

// 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // 通常为了节省电量和资源损耗，在获取到位置以后选择停止定位服务
    [self.manager stopUpdatingLocation];
    if (self.locationFailed) {
        self.locationFailed(error);
    }
    
}

// 定位状态改变
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // 4.开始定位
    [self.manager startUpdatingLocation];
    if (self.locationStatus) {
        self.locationStatus(status);
    }
    
}



@end
