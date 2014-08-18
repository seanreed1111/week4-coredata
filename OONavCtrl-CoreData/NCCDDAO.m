//
//  NCCDDAO.m
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import "NCCDDAO.h"

@implementation NCCDDAO
+ (UIManagedDocument *)sharedDocument
{
    static UIManagedDocument *document = nil;
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
                    [NCCDDAO documentIsReady:document];
                }
            }];
        } else {
            [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
                if (!success) {
                    NSLog(@"couldn't create document at %@", url);
                } else {
                  // no need to try to fetch data because file didn't exist!!!!

                }
            }];
        }
    });
    
    return document; // not threadsafe
    
    //since the openWithCompletionHandler: and saveToURL:forSaveOperation: methods do not happen on the
    //main queue, there is no guarantee that I'll be able to return a document here.
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
        NSArray *companies = [context executeFetchRequest:request error:&error]; //not threadsafe, but "USUALLY" very fast
        
    }
    
}

+ (NSMutableArray *)sharedCompanyObjects
{
    static NSMutableArray *companies = nil;
    
    return companies;
    
}

- (NSMutableArray)initCompanyObject
{
    
}

+ (NSMutableArray *)sharedCompanies
{
 //probably need to make a sharedDocument method
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
    
    dispatch_once(&dispatch_once_token, ^{
    // initialize UIManaged Document instance
        
    // if they exist, add them to companies.
        
    // else companies  = [NCCDAO loadCompanies]
    
    
    });
    
    
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
