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
#import "Company+Create.h"

@interface NCCDDAO : NSObject

@property(strong, nonatomic) UIManagedDocument *doc;
@property(strong, nonatomic) NSManagedObjectContext *context;
+ (NSMutableArray *)sharedCompanies;
+ (void)resetCompanies;
+ (void) penOrCreateUIManagedDocument;
+ (void)readyToImportFromDocument:(UIManagedDocument *)document;
+ (void)deleteProductAtIndex:(NSInteger)index fromCompany:(Company *)company;
@end
