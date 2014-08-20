//
//  Company+Create.m
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import "Company+Create.h"

@implementation Company (Create)

+ (Company *)createCompanyWithDictionary:(NSDictionary *)dictionary
                  inManagedObjectContext:(NSManagedObjectContext *)context
{
    Company *company = nil;
    return company;
}

//  THESE METHODS ARE FROM THE OLD OONCCompany Class
//////////////////////////
//////////////////////////
+ (Company *)createCompanyWithDictionary:(NSDictionary *)companyDictionary
{
    return [[Company alloc]initCompanyWithDictionary:companyDictionary];
}

- (Company *)initCompanyWithDictionary:(NSDictionary *)companyDictionary
{
    self = [super init];
    if (self)
    {
        NSArray *keys = [companyDictionary allKeys];
        
        //copy objects passed from dictionary into named properties of current object
        for (NSString *property in keys)
        {
            SEL setProperty = NSSelectorFromString([NSString stringWithFormat:@"set%@:",[property capitalizedString]]);
            // selector object creates the default setter names for all properties, e.g. setName:, setProducturl:, etc.
            //if property names already have a capital letter in them, this won't work.
            //Would need to write a 'capitalize first word only' method to replace 'capitalizedString' method, since the latter change all characters besides the first to lower case.
            
            if([self respondsToSelector:setProperty])
            {
                [self performSelector:setProperty
                           withObject:[companyDictionary objectForKey:property]];
            }
        }
        
    }
    return self;
}
























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
        company.companyurl = [companyDictionary valueForKey:@"companyurl"];
        company.companyimagename = [companyDictionary valueForKey:@"companyimagename"];
        company.companyimagepath = [companyDictionary valueForKey:@"companyimagepath"];
        company.price = [companyDictionary valueForKey:@"price"];
//      TTD
//      Must now create one Product for each member of company.products in the dictionary
//        company.products = [companyDictionary valueForKey:@"products"];
//      need to insert into the Company model the full NSSet of products in a relationship with this company one at a time
        
    }
    
    return company;
}

+ (Company *)createCompanyWithManagedObjectContext:(NSManagedObjectContext *)context;
{
    return ([NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:context]);
}
@end
