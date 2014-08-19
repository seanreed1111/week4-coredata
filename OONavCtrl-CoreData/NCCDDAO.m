//
//  NCCDDAO.m
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import "NCCDDAO.h"

@implementation NCCDDAO

static UIManagedDocument *document = nil;
static NSMutableArray *companies = nil;

+ (void)initSharedDocument
{
    static dispatch_once_t dispatch_once_token;
    dispatch_once(&dispatch_once_token, ^{
        // initialize UIManaged Document instance
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSString *documentName = @"NCCDAO";
        NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
        document = [[UIManagedDocument alloc]initWithFileURL:url];


        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
        if (fileExists) {
            [document openWithCompletionHandler:^(BOOL success){
                if (!success) {
                    NSLog(@"couldn't open document at %@", url);
                } else {
                    [NCCDDAO documentIsReady:document]; // ready to load companies
                }
            }];
        } else {
            [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
                if (!success) {
                    NSLog(@"couldn't create document at %@", url);
                }
            }];
        }
    });

}

+ (void)documentIsReady:(UIManagedDocument *)document
{   //loads data from Core Data persistent store into current context
    NSLog(@"NCCDAO documentIsReady:document = %@",document);
    

    //This method is guaranteed to be on the same main thread since
    // message is sent ONLY within the completion handler for openWithCompletionHandler:
    //under the sharedDocument Dispatch once
    
    if (document.documentState == UIDocumentStateNormal)
    {

        NSManagedObjectContext *context = document.managedObjectContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Company"];
        request.fetchBatchSize = 20;
        request.fetchLimit = 100;
        request.predicate = nil;
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"companyname"
                                                                  ascending:YES
                                                                   selector:@selector(localizedStandardCompare:)]];
        NSError *error;
        NSArray *companies = [context executeFetchRequest:request error:&error]; //not threadsafe
        NSLog(@"Companies = %@",companies);
    }
    
}

//+ (void)executeFetchRequest:(NSFetchRequest *)request forContext:(NSManagedObjectContext *)context error:(NSError *)error completionHandler:^()
//{
//    
//}


+ (NSMutableArray *)sharedCompanies
{
 //the first time this method is called
      //it must run from a completion handler so that it has an "ready" UIManagedDocument
//    then, companies are initially loaded once from the Core Data persistent store
    

 // NSMutableArray of OONCCompany objects
    
    
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
    
    [[[NCCDDAO sharedCompanies][companyIndex] products] removeObjectAtIndex:productIndex];
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
