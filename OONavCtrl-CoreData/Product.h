//
//  Product.h
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/18/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Company;

@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Company *company;

@end
