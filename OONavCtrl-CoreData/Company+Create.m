//
//  Company+Create.m
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import "Company+Create.h"

@implementation Company (Create)

+ (Company *)companyWithDictionary:(NSDictionary *)companyDictionary
            inManagedObjectContext:(NSManagedObjectContext *)context
{
    Company *company = nil;
    
    //Ask the DB is the company is already there by trying to fetch it
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"Company"];
    //create a predicate for the fetch request - this is just a placeholder
    // not quite sure if I've done this right
    request.predicate = [NSPredicate predicateWithFormat:@"companyname =%@",[companyDictionary valueForKey:@"companyname"]];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || error ||[matches count] >1)
    {
        //handle error
        
    } else if ([matches count])
    {   //company exists in database already so return it

        company = [matches firstObject];
    } else
    { // create a brand new company in the database
        company = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:context];
        company.companyname = [companyDictionary valueForKey:@"companyname"];
        company.companyname = [companyDictionary valueForKey:@"companyname"];
        company.companyname = [companyDictionary valueForKey:@"companyname"];
        company.companyname = [companyDictionary valueForKey:@"companyname"];
        company.companyname = [companyDictionary valueForKey:@"companyname"];
//      TTD
//      Must now create one Product for each member of company.products
//        company.products = [companyDictionary valueForKey:@"products"];
//      need to insert into the Company model the full NSSet of products in a relationship with this company one at a time
        
    }
    
    return company;
}
@end
