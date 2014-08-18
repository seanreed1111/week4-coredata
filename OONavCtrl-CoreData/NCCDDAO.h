//
//  NCCDDAO.h
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OONCCompany.h"

@interface NCCDDAO : NSObject //<NSCoding>

@property(strong, nonatomic) UIManagedDocument *document;
+ (void)resetCompanies;
+ (NSMutableArray *)loadCompanies;
+ (NSMutableArray *)sharedCompanies;


+(void)deleteProductAtIndex:(NSUInteger)productIndex fromCompany:(OONCCompany *)company;

//////////////////////////////////////////
// DETERMINE IF NSCODER PROTOCOL IS NEEDED
//////////////////////////////////////////

//-(void)encodeWithCoder:(NSCoder *)coder;
//-(id)initWithCoder:(NSCoder *)coder;

//+ (void)deleteProductNamed:(NSString *)name fromCompany:(OONCCompany *)company;
@end
