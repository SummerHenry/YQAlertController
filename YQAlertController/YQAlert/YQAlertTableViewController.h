//
//  YQAlertTableViewController.h
//  alert
//
//  Created by Olmysoft on 16/5/3.
//  Copyright © 2016年 Olmysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectCityAreaSuccess)(NSString *provice, NSString *city, NSString *area, NSString *code);

@interface YQAlertTableViewController : UIViewController

@property (nonatomic, copy) selectCityAreaSuccess citySelectBlock;

@end
