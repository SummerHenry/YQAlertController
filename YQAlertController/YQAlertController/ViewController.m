//
//  ViewController.m
//  YQAlertController
//
//  Created by Olmysoft on 2016/11/24.
//  Copyright © 2016年 方义强. All rights reserved.
//

#import "ViewController.h"
#import "YQAlertTableViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *valueLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)didPushClick:(UIButton *)sender {
    YQAlertTableViewController *alertVc = [[YQAlertTableViewController alloc] init];
    alertVc.providesPresentationContextTransitionStyle = YES;
    alertVc.definesPresentationContext = YES;
    alertVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    __block ViewController *weakSelf = self;
    alertVc.citySelectBlock = ^(NSString *provice, NSString *city, NSString *area, NSString *code){
        weakSelf.valueLab.text = [NSString stringWithFormat:@"%@-%@-%@-%@", provice, city, area, code];
    };
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
