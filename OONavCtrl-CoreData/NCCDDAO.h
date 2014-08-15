//
//  NCCDDAO.h
//  OONavCtrl-CoreData
//
//  Created by Sean Reed on 8/15/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OONCCompany.h"

@interface NCCDDAO : NSObject <NSCoding>
+ (void)resetCompanies;

+ (NSMutableArray *)sharedCompanies;

//+ (void)deleteProductNamed:(NSString *)name fromCompany:(OONCCompany *)company;
+ (NSMutableArray *)loadCompanies;
+(void)deleteProductAtIndex:(NSUInteger)productIndex fromCompany:(OONCCompany *)company;
-(void)encodeWithCoder:(NSCoder *)coder;
-(id)initWithCoder:(NSCoder *)coder;

@end
