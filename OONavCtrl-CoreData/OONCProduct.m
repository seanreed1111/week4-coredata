//
//  OONCProduct.m
//  OONavCtrl
//
//  Created by Sean Reed on 7/21/14.
//  Copyright (c) 2014 seanreed.test. All rights reserved.
//

#import "OONCProduct.h"

@implementation OONCProduct


+ (OONCProduct *)createProductWithDictionary:(NSDictionary*)productDictionary
{
    return [[OONCProduct alloc]initProductWithDictionary:productDictionary];
}

//designated initializer
- (OONCProduct *)initProductWithDictionary:(NSDictionary*)productDictionary
{
    self = [super init];
    if (self)
    {
        NSArray *keys = [productDictionary allKeys];
        
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
                           withObject:[productDictionary objectForKey:property]];
            }
        }
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.productname forKey:@"productname"];
    [coder encodeObject:self.producturl forKey:@"producturl"];
    [coder encodeObject:self.productimagename forKey:@"productimagename"];
    [coder encodeObject:self.productimagepath forKey:@"productimagepath"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    //implement this method
    self = [super init];
    if(!self){
        return nil;
    }
    self.productname = [coder decodeObjectForKey:@"productname"];
    self.producturl = [coder decodeObjectForKey:@"producturl"];
    self.productimagename = [coder decodeObjectForKey:@"productimagename"];
    self.productimagepath = [coder decodeObjectForKey:@"productimagepath"];
    return self;
}
@end