//
//  SLCityModel.m
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import "SLCityModel.h"



#define kMargin 13
#define kButtonWidth 91
#define kGap (kScreenWidth - kButtonWidth * 3 - kMargin - 25) / 2
#define kButtonHeight 27
#define kGapH 9
#define kTopMargin 34

@implementation SLCityModel


+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list": [SLCityList class], @"hotCity" : [SLCity class]};
}



- (CGFloat)hotCellH {
    
    NSInteger count = 0;
    CGFloat y = 0.0;
    NSInteger x = 1;
    
    for (int i = 1; i <= self.hotCity.count; i++) {
        
        if (self.hotCity.count > count ) {
            
            if (((kScreenWidth) - (kMargin + kButtonWidth * (x - 1) + kGap * (x - 1))) <= kButtonWidth) {
                y += kGapH + kButtonHeight;
                x = 1;
            }
            
            count ++;
            x ++;
            
        }
        
        
    }
    
    return y + kButtonHeight + kTopMargin + 11;
    
    
    
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
