//
//  NCCDDAO.h
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Company.h"

@interface NCCDDAO : NSObject

@property(strong, nonatomic) UIManagedDocument *document;
+ (void)initSharedDocument;
+ (void)documentIsReady:(UIManagedDocument *)document;
+ (NSMutableArray *)loadCompanies;

@end
