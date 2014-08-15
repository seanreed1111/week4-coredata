//
//  OONCProduct.h
//  OONavCtrl
//
//  Created by Sean Reed on 7/21/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OONCProduct : NSObject<NSCoding>
@property(nonatomic, copy) NSString *productname;
@property(nonatomic, copy) NSString *producturl;
@property(nonatomic, copy) NSString * productimagename;
@property(nonatomic, copy) NSString * productimagepath;


+ (OONCProduct *)createProductWithDictionary:(NSDictionary*)productDictionary;

- (OONCProduct *)initProductWithDictionary:(NSDictionary*)productDictionary;

@end
