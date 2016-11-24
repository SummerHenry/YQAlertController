//
//  YQAlertTableViewController.m
//  alert
//
//  Created by 方义强 on 16/5/3.
//  Copyright © 2016年 方义强. All rights reserved.
//

#import "YQAlertTableViewController.h"
#import "YQAlertTableViewCell.h"

#define kProvinceCell @"provinceCell"
#define kCityCell @"CityCell"

@interface YQAlertTableViewController ()<UITableViewDelegate, UITableViewDataSource>

{
    BOOL flag;
}

@property (weak, nonatomic) IBOutlet UITableView *provinceTableView;

@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) NSMutableArray *provinceArray;
@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, strong) NSMutableArray *areaArr;
@property (nonatomic, strong) NSMutableArray *selectedArray;//是否被点击
@property (nonatomic, assign) BOOL isSelProvince;
@property (nonatomic, strong) NSString *selectProvince;


@end

@implementation YQAlertTableViewController

- (NSMutableArray *)provinceArray
{
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _provinceArray;
}


- (void)viewDidLayoutSubviews
{
    if (flag) {
        self.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        flag = NO;
    }
    [super viewDidLayoutSubviews];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getDataFromJson];
    flag = YES;
    self.provinceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.cityTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.provinceTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YQAlertTableViewCell class]) bundle:nil] forCellReuseIdentifier:kProvinceCell];
    [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didViewAction)]];
    
    
}

- (void)didViewAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)getDataFromJson
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.provinceArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves) error:nil];
    [_provinceTableView reloadData];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.cityTableView) {
        return _selectedArray.count;
    }
    else
    {
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.provinceTableView) {
        return self.provinceArray.count;
    }
    else
    {
        //判断section的标记是否为1,如果是说明为展开,就返回真实个数,如果不是就说明是缩回,返回0.
        if ([_selectedArray[section] isEqualToString:@"1"])
        {
            return [_cityArr[section][@"children"] count];
        }
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.provinceTableView) {
        YQAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProvinceCell forIndexPath:indexPath];

        cell.nameLab.text = self.provinceArray[indexPath.row][@"name"];
        return cell;
    }
    else
    {
        YQAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCityCell forIndexPath:indexPath];
        cell.nameLab.font = [UIFont systemFontOfSize:12];
        cell.nameLab.backgroundColor = [UIColor colorWithRed:224 / 255.0 green:224 / 255.0 blue:224 / 255.0 alpha:1.0];
        cell.nameLab.text = _cityArr[indexPath.section][@"children"][indexPath.row][@"name"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.provinceTableView) {
        
        self.cityTableView.dataSource = self;
        self.cityTableView.delegate = self;
        [self.cityTableView registerNib:[UINib nibWithNibName:NSStringFromClass([YQAlertTableViewCell class]) bundle:nil] forCellReuseIdentifier:kCityCell];
        _isSelProvince = YES;
        _cityArr  = [NSMutableArray arrayWithCapacity:0];
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
        _selectProvince = self.provinceArray[indexPath.row][@"name"];
        for (NSDictionary *dic in self.provinceArray) {
            if ([dic[@"name"] isEqualToString:self.provinceArray[indexPath.row][@"name"]]) {
                _cityArr = dic[@"children"];
            }
        }
        for (NSDictionary *dic in _cityArr) {
            [_selectedArray addObject:@"0"];
        }
        
        [_cityTableView reloadData];
    }
    else
    {
        if (tableView == self.cityTableView) {
            self.citySelectBlock( _selectProvince, _cityArr[indexPath.section][@"name"], _cityArr[indexPath.section][@"children"][indexPath.row][@"name"] , _cityArr[indexPath.section][@"children"][indexPath.row][@"code"]);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.cityTableView) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ([[UIScreen mainScreen] bounds].size.width - 60 ) / 2, 44)];
        headView.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1.0];
        UIButton *cityNameLab = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [cityNameLab setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        cityNameLab.frame = CGRectMake(0, 0, ([[UIScreen mainScreen] bounds].size.width - 60 ) / 2, 44);
        [cityNameLab setTitle:self.cityArr[section][@"name"] forState:(UIControlStateNormal)];
        [cityNameLab setTitleColor:[UIColor colorWithRed:59 / 255.0 green:116 / 255.0 blue:188 / 255.0 alpha:1.0] forState:(UIControlStateNormal)];
        cityNameLab.titleLabel.font = [UIFont systemFontOfSize:13];
        cityNameLab.titleLabel.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:cityNameLab];
        cityNameLab.tag = section + 100;
        [cityNameLab addTarget:self action:@selector(didHeadSectionView:) forControlEvents:(UIControlEventTouchUpInside)];
        return headView;
    }
    else
    {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.cityTableView) {
        return 44;
    }
    else
    {
        return 0;
    }
}


- (void)didHeadSectionView:(UIButton *)btn
{
    _areaArr = [NSMutableArray arrayWithCapacity:0];
    _areaArr = _cityArr[btn.tag - 100][@"children"];
    
    if ([_selectedArray[btn.tag - 100] isEqualToString:@"0"]) {
        [_selectedArray replaceObjectAtIndex:btn.tag - 100 withObject:@"1"];
        [_cityTableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag - 100] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        //如果当前点击的section是展开的,那么点击后就需要把它缩回,使_selectedArray对应的值为0,这样当前section返回cell的个数变成0,然后刷新这个section就行了
        [_selectedArray replaceObjectAtIndex:btn.tag - 100 withObject:@"0"];
        [_cityTableView reloadSections:[NSIndexSet indexSetWithIndex:btn.tag - 100] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
