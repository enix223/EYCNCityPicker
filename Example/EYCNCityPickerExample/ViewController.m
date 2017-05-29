//
//  ViewController.m
//  EYCNCityPickerExample
//
//  Created by Enix Yu on 29/5/2017.
//  Copyright © 2017 Robotbros. All rights reserved.
//

#import <EYCNCityPicker.h>
#import <EYCNCityService.h>
#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, copy) NSString *selectProvinceValue;
@property (nonatomic, copy) NSString *selectCityValue;
@property (nonatomic, copy) NSString *selectDistrictValue;

@property (nonatomic, assign) NSInteger selectProvinceIdx;
@property (nonatomic, assign) NSInteger selectCityIdx;
@property (nonatomic, assign) NSInteger selectDistrictIdx;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
    
    [_selectButton addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialize {
    EYCNCityService *service = [[EYCNCityService alloc] initWithAPIKey:@"699161121d34385622a16ca815c6a934"];
    [service requestCNCitiesWithCompletion:^(NSArray * _Nullable cities, NSError * _Nullable error) {
        if (error) {
            NSLog(@"获取行政区域失败，原因: %@", error.localizedDescription);
        } else {
            self.data = cities;
        }
    }];
}

- (void)showPicker:(id)sender {
    if (self.data == nil) {
        NSLog(@"数据不能为空");
        return;
    }
    
    NSDictionary *attr = @{NSForegroundColorAttributeName: [UIColor darkGrayColor],
                           NSFontAttributeName: [UIFont systemFontOfSize:16]};
    
    NSArray *selections = @[@(_selectProvinceIdx), @(_selectCityIdx), @(_selectDistrictIdx)];
    
    EYCNCityPicker *picker = [EYCNCityPicker buildPicker];
    [picker
     showInView:self.view
     withData:self.data
     initialSelctions:selections
     itemAttributes:attr
     cancel:^(EYCNCityPicker *picker) {
         NSLog(@"User canceled");
         [self.selectButton setTitle:@"未选择" forState:UIControlStateNormal];
     } confirmBlock:^(EYCNCityPicker * _Nonnull picker, NSInteger selectedProvinceIdx, NSInteger selectedCityIdx, NSInteger selectedDistrictIdx, NSString * _Nullable selectProvince, NSString * _Nullable selectCity, NSString * _Nullable selectDistrict) {
         self.selectProvinceValue = selectProvince;
         self.selectCityValue = selectCity == nil ? @"" : selectCity;
         self.selectDistrictValue = selectDistrict == nil ? @"" : selectDistrict;
         
         self.selectProvinceIdx = selectedProvinceIdx;
         self.selectCityIdx = selectedCityIdx;
         self.selectDistrictIdx = selectedDistrictIdx;
         
         NSString *selection = [NSString stringWithFormat:@"%@, %@, %@", _selectProvinceValue, _selectCityValue, _selectDistrictValue];
         [self.selectButton setTitle:selection forState:UIControlStateNormal];
     }];
}

@end
