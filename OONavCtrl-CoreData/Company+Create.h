//
//  Company+Create.h
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import "Company.h"

@interface Company (Create)

+ (Company *)companyWithDictionary:(NSDictionary *)dictionary
            inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Company *)createCompanyWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
