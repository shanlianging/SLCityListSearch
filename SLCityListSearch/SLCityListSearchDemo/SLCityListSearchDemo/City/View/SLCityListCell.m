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

/** 选择城市对勾 */
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
        if (city.isSelected) {
            self.citySelectedImageView.hidden = NO;
        } else {
            self.citySelectedImageView.hidden = YES;
        }
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
