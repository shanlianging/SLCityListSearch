//
//  SDCityListCell.m
//  sudaizhijia
//
//  Created by 武传亮 on 2017/4/28.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import "SLCityListCell.h"
#import "SLCityModel.h"

@interface SLCityListCell ()

/** 城市名称 */
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

/** 选择城市图片 */
@property (weak, nonatomic) IBOutlet UIImageView *citySelectedImageView;

@end

@implementation SLCityListCell

- (void)awakeFromNib {
    [super awakeFromNib];


}


- (void)setCity:(SLCity *)city {
    if (_city != city) {
        _city = city;
        self.cityNameLabel.text = city.name;
        self.citySelectedImageView.hidden = !city.isSelected;
    }
}




@end
