//
//  SBMutableDictionary.m
//  Statistics
//
//  Created by Stig Brautaset on 10/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import "SBMutableDictionary.h"


@implementation NSMutableDictionary (SBMutableDictionary)

- (void)incrementValueForNumber:(NSNumber*)key
{
    id value = [self objectForKey:key];
    value = value ? [NSNumber numberWithInt:[value intValue] + 1]
                  : [NSNumber numberWithInt:1];

    [self setObject:value forKey:key];
}

@end
