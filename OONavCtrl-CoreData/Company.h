//
//  Company.h
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/18/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Product;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * companyimagename;
@property (nonatomic, retain) NSString * companyimagepath;
@property (nonatomic, retain) NSString * companyname;
@property (nonatomic, retain) NSString * companyurl;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSSet *products;
@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addProductsObject:(Product *)value;
- (void)removeProductsObject:(Product *)value;
- (void)addProducts:(NSSet *)values;
- (void)removeProducts:(NSSet *)values;

@end
