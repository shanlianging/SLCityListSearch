//
//  SLCityListViewController.m
//  SLCityListSearchDemo
//
//  Created by 武传亮 on 2017/6/26.
//  Copyright © 2017年 武传亮. All rights reserved.
//

#import "SLCityListViewController.h"

#import "SLCityHeadView.h"
#import "SLCityListCell.h"
#import "SLHotCityCell.h"
#import "CityMacros.h"
#import "SLCityLocationView.h"
#import "SLLocationHelp.h"



@interface SLCityListViewController ()<UITableViewDelegate, UITableViewDataSource>


/** 列表视图 */
@property (strong, nonatomic) UITableView *tableView;
/** 定位视图 */
@property (strong, nonatomic) SLCityLocationView *cityLocationView;
/** 区头视图 */
@property (strong, nonatomic) SLCityHeadView *cityHeadView;
/** 是否开始拖拽 */
@property (assign, nonatomic, getter=isBegainDrag) BOOL begainDrag;
/** 区头数组 */
@property (strong, nonatomic) NSMutableArray *sectionArray;
/** 分区中心动画label */
@property (strong, nonatomic) UILabel *sectionTitle;
/** 定位城市ID */
@property (assign, nonatomic) NSInteger Id;


@end


#define kSectionTitleWidth 50
#define kTimeInterval 1



@implementation SLCityListViewController

#pragma mark -- 懒加载
// 区头数组
- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray new];
        for (SLCityList *cityList in self.cityModel.list) {
            [_sectionArray addObject:cityList.initial];
        }
        [_sectionArray insertObject:@"热门" atIndex:0];
    }
    return _sectionArray;
}

// 分区动画标题
- (UILabel *)sectionTitle {
    if (!_sectionTitle) {
        _sectionTitle = [UILabel new];
        _sectionTitle.backgroundColor = [UIColor redColor];
        _sectionTitle.textColor = [UIColor whiteColor];
        _sectionTitle.layer.cornerRadius = kSectionTitleWidth / 2.0;
        _sectionTitle.layer.masksToBounds = YES;
        _sectionTitle.alpha = 0;
        _sectionTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _sectionTitle;
}

- (SLCityModel *)cityModel {
    if (!_cityModel) {
        NSString *path = [[NSBundle mainBundle] pathForResource:kCityData ofType:nil];
        NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
        _cityModel = [SLCityModel mj_objectWithKeyValues:data];
    }
    return _cityModel;
}

// 定位视图
- (SLCityLocationView *)cityLocationView {
    if (!_cityLocationView) {
        _cityLocationView = [[SLCityLocationView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    }
    return _cityLocationView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40 + 64, kScreenWidth, kScreenHeight - 64 - 40) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionIndexBackgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        _tableView.sectionIndexColor = [UIColor blueColor];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SLCityHeadView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:cityHeadView];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SLHotCityCell class]) bundle:nil] forCellReuseIdentifier:hotCityCell];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SLCityListCell class]) bundle:nil] forCellReuseIdentifier:cityListCell];
    }
    return _tableView;
}


#pragma mark -- 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置navigationBar
    [self setupNavigationBar];
    
    // 添加视图
    [self.view addSubview:self.cityLocationView];
    // 定位方法
    [self locationAction:self.cityLocationView];
    
    
    
    
    [self.cityLocationView.cityButton addTarget:self action:@selector(locationCitySelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cityLocationView.locationButton addTarget:self action:@selector(againLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];

    // 定位索引图片
    UIImageView *locationImageView = [UIImageView new];
    locationImageView.image = [UIImage imageNamed:@"location"];
    [self.view addSubview:locationImageView];
    CGFloat centerOffset = self.sectionArray.count * 13 / 2.5;
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-3.5);
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.view.mas_centerY).offset(-centerOffset);
    }];
    // 动画
    [self sectionAnimationView];

}

#pragma mark -- 设置navigationBar
- (void)setupNavigationBar {
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    // 设置标题
    self.navigationItem.title = self.cityModel.selectedCityId? [NSString stringWithFormat:@"当前选择-%@", self.cityModel.selectedCity]: @"选择城市";
    [self selectdeCity];
}
- (void)selectdeCity {
    
    // 遍历选择
    for (SLCityList *cityList in self.cityModel.list) {
        for (SLCity *city in cityList.citys) {
            
            if (city.Id == self.cityModel.selectedCityId) {
                city.selected = YES;
            } else {
                city.selected = NO;
            }
        }
    }
    
    
}

#pragma mark -- 定位
/// 定位选择
- (void)locationCitySelected:(UIButton *)button {

    if (_delegate && [_delegate respondsToSelector:@selector(sl_cityListSelectedCity:Id:)]) {
        
        [_delegate sl_cityListSelectedCity:button.titleLabel.text Id:self.Id];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}
/// 重新定位
- (void)againLocation:(UIButton *)button {
    [self locationAction:self.cityLocationView];
}

/// 定位
- (void)locationAction:(SLCityLocationView *)cityLocationView {
    
    __weak typeof(self) weakSelf = self;
    [[SLLocationHelp sharedInstance] getLocationPlacemark:^(CLPlacemark *placemark) {
        
        if (placemark.locality) {
            
            cityLocationView.cityButton.enabled = YES;
            cityLocationView.locationCity = placemark.locality;
            
            if (weakSelf.Id == 0) {
                BOOL flag = NO;
                for (SLCity *city in weakSelf.cityModel.hotCity) {
                    if ([placemark.locality containsString:city.name]) {
                        weakSelf.Id = city.Id;
                        flag = YES;
                        break;
                    }
                }
                if (!flag) {
                    for (SLCityList *cityList in weakSelf.cityModel.list) {
                        for (SLCity *city in cityList.citys) {
                            if ([placemark.locality containsString:city.name]) {
                                weakSelf.Id = city.Id;
                                break;
                            }
                            
                        }
                    }
                }
            }
            
            
        } else {
            cityLocationView.cityButton.enabled = NO;
            cityLocationView.locationCity = @"定位失败";
        }
        
    } status:^(CLAuthorizationStatus status) {
        
        if (status != kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedWhenInUse) {
            //定位不能用
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"允许“城市列表”在您使用该应用时访问您的位置吗？" message:@"是否允许访问您的位置？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        } else {
            
            cityLocationView.locationCity = @"定位中...";
            cityLocationView.cityButton.enabled = NO;
        }
        
        
    } didFailWithError:^(NSError *error) {
        cityLocationView.locationCity = @"定位失败";
        cityLocationView.cityButton.enabled = NO;

    }];
    
}


#pragma mark -- 分区中心动画视图添加
- (void)sectionAnimationView {
    [self.tableView.superview addSubview:self.sectionTitle];
    [self.sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.tableView.superview);
        make.width.height.mas_equalTo(kSectionTitleWidth);
    }];
}


#pragma mark -- tableView 的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section? self.cityModel.list[section - 1].citys.count: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SLHotCityCell *hotCell = [tableView dequeueReusableCellWithIdentifier:hotCityCell forIndexPath:indexPath];
        hotCell.cityModel = self.cityModel;
        __weak typeof(self) weakSelf = self;
        hotCell.selectedCityBlock = ^(NSString *selectedCity, NSInteger Id) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sl_cityListSelectedCity:Id:)]) {
                [weakSelf.delegate sl_cityListSelectedCity:selectedCity Id:Id];
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            
        };
        
        return hotCell;
    }
    
    SLCityListCell *cell = [tableView dequeueReusableCellWithIdentifier:cityListCell forIndexPath:indexPath];
    cell.city = self.cityModel.list[indexPath.section - 1].citys[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.section? 33: self.cityModel.hotCellH;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section? 18: 0.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    self.cityHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cityHeadView];
    
    self.cityHeadView.titleLabel.text = self.sectionArray[section];
    
    return self.cityHeadView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) return;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sl_cityListSelectedCity:Id:)]) {
        
        SLCity *city = self.cityModel.list[indexPath.section - 1].citys[indexPath.row];
        [_delegate sl_cityListSelectedCity:city.name Id:city.Id];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}




- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    
    // 结束拖拽
    self.begainDrag = NO;
    
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.sectionTitle.alpha = 1.0;
        [self.sectionTitle.layer removeAllAnimations];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kTimeInterval animations:^{
            self.sectionTitle.alpha = 0.;
        }];
    }];
    
    return index;
    
}



#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    UITableView *tableView = (UITableView *)scrollView;
    NSArray *array = [tableView indexPathsForRowsInRect:CGRectMake(0, tableView.contentOffset.y, kScreenWidth, 20)];
    NSIndexPath *indexPath = [NSIndexPath new];
    indexPath = array.count? array[0]: [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.sectionTitle.text = self.sectionArray[indexPath.section];
    
    // 是否开始拖拽
    if (self.isBegainDrag) {
        [UIView animateWithDuration:kTimeInterval animations:^{
            self.sectionTitle.alpha = 1.0;
        }];
    }
    
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.begainDrag = YES;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.sectionTitle.alpha = 0.;
    }];
    
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    self.begainDrag = NO;
    if (!velocity.y) {
        [UIView animateWithDuration:kTimeInterval animations:^{
            self.sectionTitle.alpha = 0.;
        }];
        
    }
    
    
}


- (void)dealloc {
    
}

@end
