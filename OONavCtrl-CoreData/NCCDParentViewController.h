//
//  NCCDParentViewController.h
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCCDDAO.h"
#import "NCCDChildViewController.h"

@interface NCCDParentViewController : UITableViewController <NSURLConnectionDelegate , NSURLConnectionDataDelegate>
@property(strong, nonatomic)NCCDChildViewController *childVC;
@property(strong, nonatomic)NSMutableData *receivedData;
@property(strong, nonatomic)NSMutableDictionary *stockPrices;

-(void)asynchGetPriceFromStockTicker:(NSString *)ticker;
-(void)asynchGetPricesFromCompanies:(NSArray *)companies;// of OONCCompany objects
@end
