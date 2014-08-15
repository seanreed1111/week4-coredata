//
//  NCCDChildViewController.h
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OONCCompany.h"
#import "NCCDWebViewController.h"

@interface NCCDChildViewController : UITableViewController
@property(strong, nonatomic) OONCCompany *company;
@property(strong, nonatomic)NCCDWebViewController *webVC;
@end