//
//  OONCParentViewController.h
//  OONavCtrl
//
//  Created by Sean Reed on 7/23/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OONCDAO.h"
#import "OONChildViewController.h"

@interface OONCParentViewController : UITableViewController <NSURLConnectionDelegate , NSURLConnectionDataDelegate>

@property(strong, nonatomic)OONChildViewController *childVC;
@property(strong, nonatomic)NSMutableData *receivedData;
@property(strong, nonatomic)NSMutableDictionary *stockPrices;

-(void)asynchGetPriceFromStockTicker:(NSString *)ticker;
-(void)asynchGetPricesFromCompanies:(NSArray *)companies;// of OONCCompany objects
@end
