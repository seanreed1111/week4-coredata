//
//  Product+Create.h
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import "Product.h"

@interface Product (Create)

+ (Product *)fetchProductWithName:(NSString *)name
    inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Product *)createProductWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
