//
//  OONChildViewController.h
//  OONavCtrl
//
//  Created by Sean Reed on 7/23/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OONCCompany.h"
#import "OONCWebViewController.h"

@interface OONChildViewController : UITableViewController
@property(strong, nonatomic) OONCCompany *company;
@property(strong, nonatomic)OONCWebViewController *webVC;
@end
