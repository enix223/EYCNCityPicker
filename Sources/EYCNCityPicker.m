//
//  EYCNCityPicker.m
//  LehuisoApp
//
//  Created by Enix Yu on 27/5/2017.
//  Copyright © 2017 RobotBros. All rights reserved.
//

#import "EYCNCityPicker.h"

#define EYCNCityPickerHeight 250

@interface EYCNCityPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, copy) NSString *selectProvinceValue;
@property (nonatomic, copy) NSString *selectCityValue;
@property (nonatomic, copy) NSString *selectDistrictValue;

@property (nonatomic, assign) NSInteger lastRow;

@end

@implementation EYCNCityPicker

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelectProvinceIdx:(NSInteger)selectProvinceIdx {
    _selectProvinceIdx = selectProvinceIdx;
    
    [self.cityPicker reloadComponent:1];
    [self.cityPicker selectRow:0 inComponent:1 animated:YES];
    
    self.selectCityIdx = 0;
}

- (void)setSelectCityIdx:(NSInteger)selectCityIdx {
    _selectCityIdx = selectCityIdx;
    _selectDistrictIdx = 0;
    
    [self.cityPicker reloadComponent:2];
    [self.cityPicker selectRow:0 inComponent:2 animated:YES];
}

+ (instancetype)buildPicker {
    NSBundle *bundle = [NSBundle bundleForClass:[EYCNCityPicker class]];
    return [[[UINib nibWithNibName:@"EYCNCityPicker" bundle:bundle]
             instantiateWithOwner:nil options:nil] firstObject];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_data count];
    } else if (component == 1) {
        NSDictionary *item = [_data objectAtIndex:_selectProvinceIdx];
        NSArray *cities = [item objectForKey:@"c"];
        return [cities count];
    } else if (component == 2) {
        NSDictionary *item1 = [_data objectAtIndex:_selectProvinceIdx];
        NSArray *cities = [item1 objectForKey:@"c"];
        NSDictionary *item2 = [cities objectAtIndex:_selectCityIdx];
        NSArray *districts = [item2 objectForKey:@"c"];
        return [districts count];
    }
    
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    UILabel *label = (UILabel *)view;
    if (label == nil) {
        label = [[UILabel alloc] init];
    }
    
    NSDictionary *attrs =
        self.itemAttributes == nil ?
                @{NSForegroundColorAttributeName: [UIColor darkGrayColor],
                  NSFontAttributeName: [UIFont systemFontOfSize:15]}
                : self.itemAttributes;
    NSString *str;
    if (component == 0) {
        str = [self provinceAtRow:row];
    } else if (component == 1) {
        str = [self cityAtRow:row];
    } else if (component == 2) {
        str = [self districtForRow:row];
    }
    
    NSAttributedString *astr = [[NSAttributedString alloc] initWithString:str attributes:attrs];
    label.attributedText = astr;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.minimumScaleFactor = 0.5;
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectProvinceIdx = row;
    } else if (component == 1) {
        self.selectCityIdx = row;
    } else if (component == 2) {
        self.selectDistrictIdx = row;
    }
}

- (void)showInView:(UIView *)view
          withData:(NSArray *)data
  initialSelctions:(NSArray<NSString *> *)selections
            cancel:(__nullable LHCityPickerCancelBlock)cancelBlock
      confirmBlock:(__nullable LHCityPickerConfirmBlock)confirmBlock {
    [self showInView:view
            withData:data
    initialSelctions:selections
      itemAttributes:nil
              cancel:cancelBlock
        confirmBlock:confirmBlock];
}

- (void)showInView:(UIView *)view
          withData:(NSArray *)data
  initialSelctions:(NSArray<NSString *> *)selections
    itemAttributes:(NSDictionary *)attributes
            cancel:(__nullable LHCityPickerCancelBlock)cancelBlock
      confirmBlock:(__nullable LHCityPickerConfirmBlock)confirmBlock {
    
    self.itemAttributes = attributes;
    self.selectProvinceIdx = [[selections firstObject] intValue];
    self.selectCityIdx = [[selections objectAtIndex:1] intValue];
    self.selectDistrictIdx = [[selections objectAtIndex:2] intValue];
    
    self.maskView = [[UIView alloc] initWithFrame:view.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [view addSubview:self.maskView];
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.5;
    }];
    
    self.frame = CGRectMake(0, view.frame.size.height, view.frame.size.width, EYCNCityPickerHeight);
    self.data = data;
    self.lastRow = [[[[[self.data lastObject] objectForKey:@"c"] lastObject] objectForKey:@"c"] count];
    self.onCancel = cancelBlock;
    self.onConfirm = confirmBlock;
    
    [view addSubview:self];
    self.cityPicker.dataSource = self;
    self.cityPicker.delegate = self;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.frame;
        frame.origin.y -= EYCNCityPickerHeight;
        self.frame = frame;
    } completion:^(BOOL finished) {
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBack:)];
        [view addGestureRecognizer:gesture];
        
        [self scrollToInitialSelection];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
}

- (NSString *)provinceAtRow:(NSInteger)row {
    NSString *str = [[_data objectAtIndex:row] objectForKey:@"p"];
    return str;
}

- (NSString *)cityAtRow:(NSInteger)row {
    NSDictionary *item = [_data objectAtIndex:_selectProvinceIdx];
    NSArray *cities = [item objectForKey:@"c"];
    
    if ([cities count] == 0) return nil;
    
    NSString *str = [[cities objectAtIndex:row] objectForKey:@"p"];
    return str;
}

- (NSString *)districtForRow:(NSInteger)row {
    NSDictionary *item1 = [_data objectAtIndex:_selectProvinceIdx];
    NSArray *cities = [item1 objectForKey:@"c"];
    NSDictionary *item2 = [cities objectAtIndex:_selectCityIdx];
    NSArray *districts = [item2 objectForKey:@"c"];
    
    if ([districts count] == 0) return nil;
    
    NSString *str = [[districts objectAtIndex:row] objectForKey:@"p"];
    return str;
}

- (void)touchBack:(UITapGestureRecognizer *)gesture {
    [self hideWithCompletion:nil];
}

- (void)hideWithCompletion:(void (^)(void))completion {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.frame;
        frame.origin.y += EYCNCityPickerHeight;
        self.frame = frame;
        
        self.maskView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
        
        if (completion != nil) {
            completion();
        }
    }];
}

- (void)cancel:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self hideWithCompletion:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.onCancel != nil) {
            strongSelf.onCancel(strongSelf);
        }
    }];
}

- (void)confirm:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self hideWithCompletion:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (self.onConfirm != nil) {
            NSString *province = [strongSelf provinceAtRow:_selectProvinceIdx];
            NSString *city = [strongSelf cityAtRow:_selectCityIdx];
            NSString *district = [strongSelf districtForRow:_selectDistrictIdx];
            
            strongSelf.onConfirm(strongSelf,
                                 _selectProvinceIdx, _selectCityIdx, _selectDistrictIdx,
                                 province, city, district);
        }
    }];
}

- (void)scrollToInitialSelection {
    [_cityPicker selectRow:_selectProvinceIdx inComponent:0 animated:YES];
    [_cityPicker selectRow:_selectCityIdx inComponent:1 animated:YES];
    [_cityPicker selectRow:_selectDistrictIdx inComponent:2 animated:YES];
}

@end
