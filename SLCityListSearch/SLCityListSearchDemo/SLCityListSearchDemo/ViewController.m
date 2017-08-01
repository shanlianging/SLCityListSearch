//
//  ViewController.m
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import "ViewController.h"
#import "SLCityListViewController.h"

@interface ViewController ()<SLCityListViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cityLable;
/** 选中城市Id */
@property (assign, nonatomic) NSInteger Id;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    SLCityListViewController *cityListVC = [SLCityListViewController new];
    
    cityListVC.delegate = self;
    cityListVC.cityModel.selectedCity = self.cityLable.text;
    cityListVC.cityModel.selectedCityId = self.Id;
    
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:cityListVC];
    
    [self presentViewController:nv animated:YES completion:nil];
    
}

- (void)sl_cityListSelectedCity:(NSString *)selectedCity Id:(NSInteger)Id {
    
    self.cityLable.text = selectedCity;
    self.Id = Id;
    
    NSLog(@"selectedCity: %@, Id: %ld", selectedCity, Id);
    
    
    
}





@end
