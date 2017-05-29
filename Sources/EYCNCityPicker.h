//
//  EYCNCityPicker.h
//  LehuisoApp
//
//  Created by Enix Yu on 27/5/2017.
//  Copyright © 2017 RobotBros. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EYCNCityPicker : UIView

/// 取消回调类型定义
typedef void (^LHCityPickerCancelBlock)(EYCNCityPicker *picker);

/// 确定回调类型定义
typedef void (^LHCityPickerConfirmBlock)(EYCNCityPicker *picker,
                                         NSInteger selectedProvinceIdx,
                                         NSInteger selectedCityIdx,
                                         NSInteger selectedDistrictIdx,
                                         NSString * _Nullable selectProvince,
                                         NSString * _Nullable selectCity,
                                         NSString * _Nullable selectDistrict);

/// 行政区域数据
@property (nonatomic, strong) NSArray *data;

/// 取消按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

/// 确定按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

/// 城市选择器
@property (weak, nonatomic) IBOutlet UIPickerView *cityPicker;

/// 选择的省份对应的index
@property (nonatomic, assign) NSInteger selectProvinceIdx;

/// 选择的城市对应的index
@property (nonatomic, assign) NSInteger selectCityIdx;

/// 选择的区域对应的index
@property (nonatomic, assign) NSInteger selectDistrictIdx;

/// pickerview元素的样式，用于构建NSAttributedString
@property (nonatomic, strong) NSDictionary *itemAttributes;

/// 取消按钮回调
@property (nonatomic, strong, nullable) LHCityPickerCancelBlock onCancel;

/// 确定按钮回调
@property (nonatomic, strong, nullable) LHCityPickerConfirmBlock onConfirm;

/**
 * @brief 构建一个选择器
 */
+ (instancetype)buildPicker;

/**
 * @brief                   显示城市选择器
 * @param view:             需要显示选择器的容器
 * @param data:             城市数据, 调用EYCNCityService的-requestCNCitiesWithCompletion:所得
 * @param initialSelctions: 初始选择
 * @param cancel:           取消回调
 * @param confirmBlock:     确定回调
 */
- (void)showInView:(UIView *)view
          withData:(NSArray *)data
  initialSelctions:(NSArray<NSNumber *> *)selections
        cancelBlock:(__nullable LHCityPickerCancelBlock)cancelBlock
      confirmBlock:(__nullable LHCityPickerConfirmBlock)confirmBlock;

/**
 * @brief                   显示城市选择器
 * @param view:             需要显示选择器的容器
 * @param data:             城市数据, 调用EYCNCityService的-requestCNCitiesWithCompletion:所得
 * @param initialSelctions: 初始选择
 * @param itemAttributes:   文字样式字典，用于选择器中每个元素对应的NSAttributedString
 * @param cancel:           取消回调
 * @param confirmBlock:     确定回调
 */
- (void)showInView:(UIView *)view
          withData:(NSArray *)data
  initialSelctions:(NSArray<NSNumber *> *)selections
    itemAttributes:(NSDictionary * _Nullable)attributes
            cancel:(__nullable LHCityPickerCancelBlock)cancelBlock
      confirmBlock:(__nullable LHCityPickerConfirmBlock)confirmBlock;

@end

NS_ASSUME_NONNULL_END
