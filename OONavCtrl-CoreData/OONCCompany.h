//
//  OONCCompany.h
//  OONavCtrl
//
//  Created by Sean Reed on 7/21/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OONCProduct.h"

@interface OONCCompany : NSObject<NSCoding>
@property(copy, nonatomic) NSString *companyname;
@property(copy, nonatomic) NSString *companyurl;
@property(copy, nonatomic) NSString *companyimagename;
@property(copy, nonatomic) NSString *companyimagepath;
@property(copy, nonatomic) NSString *ticker;
@property(strong, nonatomic) NSMutableString *price;

@property(strong, nonatomic) NSMutableArray *products; //of NSString* objects


+ (OONCCompany *)createCompanyWithDictionary:(NSDictionary *)companyDictionary;
+ (OONCCompany *)createCompanyWithCompany:(OONCCompany *)company;

- (OONCCompany *)initCompanyWithDictionary:(NSDictionary*)companyDictionary;


@end

