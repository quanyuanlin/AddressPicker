//
//  ViewController.m
//  AddressPicker
//
//  Created by admin on 2017/9/12.
//  Copyright © 2017年 xiaoyukeji. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    AddressPickerView *_pickerView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pickerView = [[AddressPickerView alloc] initWithFrame:CGRectMake(0, 0, 375, 375)];
    _pickerView.selectBlock = ^(NSString *province, NSString *city, NSString *area) {
        NSLog(@"%@ %@ %@",province,city,area);
    };
    [_pickerView reloadPicker];
    [self.view addSubview:_pickerView];
}





@end
