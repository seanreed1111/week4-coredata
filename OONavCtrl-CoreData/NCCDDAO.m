//
//  NCCDDAO.m
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import "NCCDDAO.h"

@implementation NCCDDAO
+ (NSMutableArray *)sharedCompanies
{
    static NSMutableArray *companies = nil; // NSMutableArray of OONCCompany objects
    
    static dispatch_once_t dispatch_once_token;

// reimplement this method using Core Data
    
//    dispatch_once(&dispatch_once_token, ^{
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSData *data =[defaults objectForKey:@"companiesKey"];
//        if (data)
//        {
//            companies = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        }
//        else
//        {
//            companies =  [OONCDAO loadCompanies];
//        }
//        
//    });
    
    return companies;
}

+ (void)resetCompanies;
{
    //implement this method
}

+ (NSMutableArray *)loadCompanies
{
    NSMutableArray *companies = [[NSMutableArray alloc]initWithCapacity:5];
    
    NSDictionary *microsoftDictionary = @{@"companyname":@"Microsoft",@"companyurl":@"http://microsoft.com", @"companyimagename":@"microsoft-logo.png",@"ticker":@"MSFT", @"products":[NSMutableArray arrayWithArray:@[@"Microsoft Product #1", @"Microsoft Product #2", @"Microsoft Product #3"]]};
    NSDictionary *appleDictionary = @{@"companyname":@"Apple",@"companyurl":@"http://apple.com", @"companyimagename":@"apple-logo.jpeg",@"ticker":@"AAPL",@"products":[NSMutableArray arrayWithArray:@[@"iPad", @"iPod Touch", @"iPhone"]]};
    NSDictionary *nokiaDictionary = @{@"companyname":@"Nokia",@"companyurl":@"http://nokia.com/us-en/phones/", @"companyimagename":@"nokia-logo.jpg", @"ticker":@"NOK",@"products":[NSMutableArray arrayWithArray:@[@"Nokia Product #1", @"Nokia Product #2", @"Nokia Product #3"]]};
    NSDictionary *samsungDictionary = @{@"companyname":@"Samsung",@"companyurl":@"http://samsung.com/us", @"companyimagename":@"samsung-logo.png",@"ticker":@"005930.KS",@"products":[NSMutableArray arrayWithArray:@[@"Samsung Product #1", @"Samsung Product #2", @"Samsung Product #3"]]};
    NSDictionary *blackberryDictionary = @{@"companyname":@"Blackberry",@"companyurl":@"http://microsoft.com", @"companyimagename":@"Blackberry-logo.jpg",@"ticker":@"BBRY",@"products":[NSMutableArray arrayWithArray:@[@"Blackberry Product #1", @"Blackberry Product #2", @"Blackberry Product #3"]]};
    
    [companies addObject:[OONCCompany createCompanyWithDictionary:microsoftDictionary]];
    [companies addObject:[OONCCompany createCompanyWithDictionary:appleDictionary]];
    [companies addObject:[OONCCompany createCompanyWithDictionary:nokiaDictionary]];
    [companies addObject:[OONCCompany createCompanyWithDictionary:samsungDictionary]];
    [companies addObject:[OONCCompany createCompanyWithDictionary:blackberryDictionary]];
    
    for(OONCCompany *company in companies)
    {
        company.products = (NSMutableArray *)[company products];
    }
    return companies;
}


+ (void)deleteProductAtIndex:(NSUInteger)productIndex fromCompany:(OONCCompany *)company
{
    NSUInteger companyIndex = [[NCCDDAO sharedCompanies] indexOfObjectIdenticalTo:company];
    NSMutableArray *products = [[NCCDDAO sharedCompanies][companyIndex] products];
    
    //       [[[OONCDAO sharedCompanies][companyIndex] products] removeObjectAtIndex:productIndex];
    [products removeObjectAtIndex:productIndex];
    
    NSLog(@"OONCDAO deleteProductAtIndex:(NSUInteger)productIndex fromCompany:(OONCCompany *)company");
}

//////////////////////////////////////////
// DETERMINE IF NSCODER PROTOCOL IS NEEDED
//////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:[NCCDDAO sharedCompanies] forKey:@"companiesKey"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self  = [super init];
    
    if (self)
    {
        NSMutableArray *companies = [NCCDDAO sharedCompanies];
        companies = [coder decodeObjectForKey:@"companiesKey"];
    }
    
    return self;
}

//+ (void)deleteProductNamed:(NSString *)name fromCompany:(OONCCompany *)company
//{
//    NSUInteger companyIndex = [[OONCDAO sharedCompanies] indexOfObjectIdenticalTo:company];
//    NSUInteger productIndex = [company.products indexOfObjectIdenticalTo:name];
//
//    [[[OONCDAO sharedCompanies][companyIndex] products] removeObjectAtIndex:productIndex];
//}

@end
