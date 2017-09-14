//
//  AddressPickerView.h
//  AddressPicker
//
//  Created by admin on 2017/9/14.
//  Copyright © 2017年 xiaoyukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressPickerView : UIView
<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *area;

- (void)reloadPicker;
@property (strong,nonatomic) void(^selectBlock)(NSString *province,NSString *city,NSString *area);


@end
