//
//  ViewController.m
//  pickerDemo
//
//  Created by Nevis on 16/8/25.
//  Copyright © 2016年 Nevis. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation ViewController
{
    NSMutableArray *_province;
    NSMutableDictionary *_city;
    NSMutableDictionary *_country;
    NSMutableArray * _all;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.picker.delegate = self;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    _city = [[NSMutableDictionary alloc]init];
    _country = [[NSMutableDictionary alloc]init];
    _province = [[NSMutableArray alloc]init];
    int i = 0;
    for (NSDictionary * dic in data) {
        NSString * state = [NSString stringWithFormat:@"%@",dic[@"state"]];
        [_province addObject:state];
        NSMutableArray * _cityCopy = [[NSMutableArray alloc]init];
        if (i++<4||i>=32) {
            [_city setObject:@[state] forKey:state];
            [_country setObject:_cityCopy forKey:state];
        }else{
            [_city setObject:_cityCopy forKey:state];
        }
        for (NSDictionary * city in dic[@"cities"]) {
            
            NSString * ct = [NSString stringWithFormat:@"%@",city[@"city"]];
            if (i<4||i>=32) {
                [_cityCopy addObject:ct];
            }else{
                [_cityCopy addObject:ct];
                [_country setObject:city[@"areas"] forKey:ct];
            }
        }
    }
}
#pragma mark - 该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;
}
#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (0 == component)
    {
        return _province.count;
    }
    if (1 == component) {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSString *provinceName = _province[rowProvince];
        NSArray *citys = _city[provinceName];
        return citys.count;
    }else{
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSString *provinceName = _province[rowProvince];
        NSArray *citys = _city[provinceName];
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        NSString *cityName = citys[rowCity];
        NSArray *country = _country[cityName];
        return country.count;
    }
}

#pragma mark - 该方法返回的NSString将作为UIPickerView中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (0 == component) {
        return _province[row];
    }
    if(1 == component){
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSString *provinceName = _province[rowProvince];
        NSArray *citys = _city[provinceName];
        return citys[row];
    }else{
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSString *provinceName = _province[rowProvince];
        NSArray *citys = _city[provinceName];
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        NSString *cityName = citys[rowCity];
        NSArray *country = _country[cityName];
        return country[row];
    }
}

#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(0 == component){
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    if(1 == component)
        [pickerView reloadComponent:2];
    NSInteger rowOne = [pickerView selectedRowInComponent:0];
    NSInteger rowTow = [pickerView selectedRowInComponent:1];
    NSInteger rowThree = [pickerView selectedRowInComponent:2];
    NSString *provinceName = _province[rowOne];
    NSArray *citys = _city[provinceName];
    NSString *cityName = citys[rowTow];
    NSArray *countrys = _country[cityName];
    NSLog(@"%@~%@~%@", _province[rowOne], citys[rowTow],countrys[rowThree]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
