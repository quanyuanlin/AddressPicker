//
//  AddressPickerView.m
//  AddressPicker
//
//  Created by admin on 2017/9/14.
//  Copyright © 2017年 xiaoyukeji. All rights reserved.
//

#import "AddressPickerView.h"
#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface AddressPickerView ()
{
    UIPickerView *_pickerView;
    
    NSArray *_provinces;
    NSArray *_citys;
    NSArray *_areas;
}
@end

@implementation AddressPickerView

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self addMainViewWith:frame];
        
    }
    return self;
}

-(void)addMainViewWith:(CGRect)frame
{
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _pickerView.delegate   = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
    
    NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
    NSString *path=[mainBundleDirectory stringByAppendingPathComponent:@"address.json"];
    NSURL *url=[NSURL fileURLWithPath:path];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    
    NSMutableArray *addressArray=[NSMutableArray array];
    for (NSDictionary *dict in dic) {
        [addressArray addObject:dict];
    }
    _provinces=[NSArray arrayWithArray:addressArray];
    
    [self reloadPicker];

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == PROVINCE_COMPONENT) {
        return _provinces.count;
    } else if (component == CITY_COMPONENT) {
        return _citys.count;
    } else {
        return _areas.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == PROVINCE_COMPONENT) {
        NSDictionary *dict=_provinces[row];
        return dict[@"name"];
    } else if (component == CITY_COMPONENT) {
        NSDictionary *dict=_citys[row];
        return dict[@"name"];
    } else {
        NSDictionary *dict=_areas[row];
        
        return dict[@"name"];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.frame.size.width / 3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == PROVINCE_COMPONENT) {
        NSDictionary *dict=_provinces[row];
        
        NSMutableArray *cityArray=[NSMutableArray array];
        for (NSDictionary *dic in dict[@"areas"]) {
            [cityArray addObject:dic];
        }
        _citys=[NSArray arrayWithArray:cityArray];
        
        [pickerView reloadComponent: CITY_COMPONENT];
        
        
        NSDictionary *dictArea=_citys[0];
        NSMutableArray *areaArray=[NSMutableArray array];
        for (NSDictionary *dic in dictArea[@"areas"]) {
            [areaArray addObject:dic];
        }
        _areas=[NSArray arrayWithArray:areaArray];
        
        [_pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [pickerView reloadComponent: DISTRICT_COMPONENT];
    }
    else if (component == CITY_COMPONENT) {
        NSDictionary *dict=_citys[row];
        NSMutableArray *areaArray=[NSMutableArray array];
        for (NSDictionary *dic in dict[@"areas"]) {
            [areaArray addObject:dic];
        }
        _areas=[NSArray arrayWithArray:areaArray];
        
        [_pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [pickerView reloadComponent: DISTRICT_COMPONENT];
    }
    [self updateAddress];
}
- (void)updateAddress
{
    NSDictionary *dictP= [_provinces objectAtIndex:[_pickerView selectedRowInComponent:PROVINCE_COMPONENT]];
    self.province = dictP[@"name"];
    
    
    NSDictionary *dictC= [_citys objectAtIndex:[_pickerView selectedRowInComponent:CITY_COMPONENT]];
    self.city  = dictC[@"name"];
    
    
    NSDictionary *dictA= [_areas objectAtIndex:[_pickerView selectedRowInComponent:DISTRICT_COMPONENT]];
    self.area  = dictA[@"name"];
    
    self.selectBlock(self.province, self.city, self.area);
}


- (void)reloadPicker
{    
    int rowP=0;
    int rowC=0;
    int rowA=0;
    for (int i=0; i<_provinces.count; i++) {
        NSDictionary *dict=_provinces[i];
        if ([self.province isEqualToString:dict[@"name"]]) {
            rowP=i;
            break;
        }
    }
    
    NSDictionary *dictCity=_provinces[rowP];
    NSMutableArray *cityArray=[NSMutableArray array];
    for (NSDictionary *dic in dictCity[@"areas"]) {
        [cityArray addObject:dic];
    }
    _citys=[NSArray arrayWithArray:cityArray];
    
    
    for (int i=0; i<_citys.count; i++) {
        NSDictionary *dict=_citys[i];
        if ([self.city isEqualToString:dict[@"name"]]) {
            rowC=i;
            break;
        }
    }
    
    
    NSDictionary *dictArea=_citys[rowC];
    NSMutableArray *areaArray=[NSMutableArray array];
    for (NSDictionary *dic in dictArea[@"areas"]) {
        [areaArray addObject:dic];
    }
    _areas=[NSArray arrayWithArray:areaArray];
    
    for (int i=0; i<_areas.count; i++) {
        NSDictionary *dict=_areas[i];
        if ([self.area isEqualToString:dict[@"name"]]) {
            rowA=i;
            break;
        }
    }
    
    [_pickerView selectRow: rowP inComponent: PROVINCE_COMPONENT animated: YES];
    [_pickerView reloadComponent: PROVINCE_COMPONENT];
    
    
    [_pickerView reloadComponent: CITY_COMPONENT];
    [_pickerView selectRow: rowC inComponent: CITY_COMPONENT animated: YES];
    
    
    [_pickerView reloadComponent: DISTRICT_COMPONENT];
    [_pickerView selectRow: rowA inComponent: DISTRICT_COMPONENT animated: YES];
    
}


@end
