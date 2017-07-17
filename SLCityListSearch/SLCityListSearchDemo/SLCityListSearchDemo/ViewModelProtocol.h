//
//
//  Created by zhanming on 2017/4/26.
//  Copyright © 2017年 zhanming. All rights reserved.
//

// 能组合就尽量使用组合:设计思想

#import <UIKit/UIKit.h>

@protocol ViewModelProtocol <NSObject>

- (void)bindViewModel:(UIView *)bindView;

@end
