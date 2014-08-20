//
//  NCCDDAO.m
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import "NCCDDAO.h"

@implementation NCCDDAO


static NSMutableArray *companies = nil; // of Company* objects

static NSManagedObjectContext *context = nil;
static NSFileManager *fileManager = nil;
static NSURL *documentsDirectory = nil;
static NSString *documentName = @"NCCDAO";
static NSURL *url = nil;
static UIManagedDocument *document = nil;

+ (NSMutableArray *)sharedCompanies
{
    //maybe I need my dispatch once back here...
    return companies;
}

+ (void)resetCompanies  // run on the mainQueue. dependent on DocumentIsReady
{
    NSDictionary *microsoftDictionary = @{@"companyname":@"Microsoft",@"companyurl":@"http://microsoft.com", @"companyimagename":@"microsoft-logo.png",@"ticker":@"MSFT", @"products":[NSMutableSet setWithArray:@[@"Microsoft Product #1", @"Microsoft Product #2", @"Microsoft Product #3"]]};
    NSDictionary *appleDictionary = @{@"companyname":@"Apple",@"companyurl":@"http://apple.com", @"companyimagename":@"apple-logo.jpeg",@"ticker":@"AAPL",@"products":[NSMutableSet setWithArray:@[@"iPad", @"iPod Touch", @"iPhone"]]};
    NSDictionary *nokiaDictionary = @{@"companyname":@"Nokia",@"companyurl":@"http://nokia.com/us-en/phones/", @"companyimagename":@"nokia-logo.jpg", @"ticker":@"NOK",@"products":[NSMutableSet setWithArray:@[@"Nokia Product #1", @"Nokia Product #2", @"Nokia Product #3"]]};
    NSDictionary *samsungDictionary = @{@"companyname":@"Samsung",@"companyurl":@"http://samsung.com/us", @"companyimagename":@"samsung-logo.png",@"ticker":@"005930.KS",@"products":[NSMutableSet setWithArray:@[@"Samsung Product #1", @"Samsung Product #2", @"Samsung Product #3"]]};
    NSDictionary *blackberryDictionary = @{@"companyname":@"Blackberry",@"companyurl":@"http://microsoft.com", @"companyimagename":@"Blackberry-logo.jpg",@"ticker":@"BBRY",@"products":[NSMutableSet setWithArray:@[@"Blackberry Product #1", @"Blackberry Product #2", @"Blackberry Product #3"]]};
    
    //define blocks
    
    void (^documentReadyForReadWrite)() = ^(){
        NSLog(@"documentReadyForReadWrite");
        NSLog(@"currentOperationQueue is %@", [[NSOperationQueue currentQueue] name]);
    };
    
    void (^createCompanies)() = ^(){// items must run on mainQueue
        NSLog(@"createCompanies");
        NSLog(@"currentOperationQueue is %@", [[NSOperationQueue currentQueue] name]);
        NSManagedObjectContext *context = [document managedObjectContext]; //dependent on documentReadyForReadWriteOperation
        
        [companies addObject:[Company createCompanyWithDictionary:microsoftDictionary inManagedObjectContext:context]];
        [companies addObject:[Company createCompanyWithDictionary:appleDictionary inManagedObjectContext:context]];
        [companies addObject:[Company createCompanyWithDictionary:nokiaDictionary inManagedObjectContext:context]];
        [companies addObject:[Company createCompanyWithDictionary:samsungDictionary inManagedObjectContext:context]];
        [companies addObject:[Company createCompanyWithDictionary:blackberryDictionary inManagedObjectContext:context]];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
        NSString *documentName = @"NCCDAO";
        NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
        
    };
    
    void (^saveCompanies)() = ^(){
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForOverwriting
          completionHandler:^(BOOL success) {
              if (success){
                  NSLog(@"Save was successful");
              } else {
                  NSLog(@"Save was unsuccessful");
              }
          }];
    };
    
    NSBlockOperation *documentReadyForReadWriteOperation = [NSBlockOperation blockOperationWithBlock:documentReadyForReadWrite];
    NSInvocationOperation *openOrCreateDocumentOperation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(openOrCreateUIManagedDocument) object:nil];

    NSBlockOperation *createCompaniesOperation = [NSBlockOperation blockOperationWithBlock:createCompanies];
    NSBlockOperation *saveCompaniesOperation = [NSBlockOperation blockOperationWithBlock:saveCompanies];
    
    [documentReadyForReadWriteOperation addDependency:openOrCreateDocumentOperation];
    [createCompaniesOperation addDependency:openOrCreateDocumentOperation];
    [saveCompaniesOperation addDependency:createCompaniesOperation];

    
    NSOperationQueue *myQueue = [[NSOperationQueue alloc]init];
    myQueue.name = @"My Queue";
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    [myQueue addOperation:saveCompaniesOperation];
    [myQueue addOperation:openOrCreateDocumentOperation];
    [mainQueue addOperation:createCompaniesOperation];
    
}

+ (void) openOrCreateUIManagedDocument
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"NCCDAO";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    document = [[UIManagedDocument alloc]initWithFileURL:url];
    void (^documentReadyForReadWrite)() = ^(){
        NSLog(@"fileReadyForReadWrite");
        NSLog(@"currentOperationQueue is %@", [[NSOperationQueue currentQueue] name]);
    };


    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    if (fileExists)
    {
        [document openWithCompletionHandler:^(BOOL success){ //async! CompletionHandler runs on main queue
            if (!success) {
                NSLog(@"couldn't open document at %@", url);
            } else {
                // ready to load companies
            }
        }];
    } else {
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){//async! CompletionHandler is on main queue

            if (!success) {
                NSLog(@"couldn't create document at %@", url);
            } else {
                // Empty document has been created.
            }
        }];
    }
    
    // when this method ends, no guarantee that it has returned the completionHandler
}

+ (void)readyToImportFromDocument:(UIManagedDocument *)document    // dependent on openOrCreateUIManagedDocument
{   //loads data from Core Data persistent store into current context
    NSLog(@"NCCDAO documentIsReady:document = %@",document);
    

    //This method is guaranteed to be on the same main thread since
    // message is sent ONLY within the completion handler for openWithCompletionHandler:
    
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
        NSArray *companies = [context executeFetchRequest:request error:&error];
        NSLog(@"Companies = %@",companies);
    }
    
}
@end
