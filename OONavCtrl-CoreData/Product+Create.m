//
//  Product+Create.m
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import "Product+Create.h"

@implementation Product (Create)
+ (Product *)productWithName:(NSString *)name
      inManagedObjectContext:(NSManagedObjectContext *)context
{
    Product *product = nil;
    NSFetchRequest *request =[NSFetchRequest fetchRequestWithEntityName:@"Product"];
    //create a predicate for the fetch request - this is just a placeholder
    // not quite sure if I've done this right
    request.predicate = [NSPredicate predicateWithFormat:@"name =%@",name];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || error ||[matches count] >1) {
    
        //handle error
        
    } else if ([matches count]){
       //product exists in database already so return it
        
        product = [matches firstObject];
    } else {
     // create a brand new product in the database
        product = [Product createProductWithManagedObjectContext:context];
        product.name = name;
    }
    return product;
}

+ (Product *)createProductWithManagedObjectContext:(NSManagedObjectContext *)context
{
    return ([NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context]);
}
@end
