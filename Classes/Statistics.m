//
//  Statistics.m
//  Statistics
//
//  Created by Stig Brautaset on 09/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import "Statistics.h"


@implementation NSArray (Statistics)

- (double)min
{
    NSAssert([self count], nil);
    NSArray *sorted = [self sortedArrayUsingSelector:@selector(compare:)];
    return [[sorted objectAtIndex:0] doubleValue];
}

- (double)max
{
    NSAssert([self count], nil);
    NSArray *sorted = [self sortedArrayUsingSelector:@selector(compare:)];
    return [[sorted lastObject] doubleValue];
}

- (double)mean
{
    NSAssert([self count], nil);

    double mean = 0.0;
    NSInteger n = 0;
    for (id d in self)
        mean += ([d doubleValue] - mean) / ++n;
    return mean;
}

- (double)median
{
    NSAssert([self count], nil);

    NSUInteger count = [self count];
    NSArray *sorted = [self sortedArrayUsingSelector:@selector(compare:)];
    if (count & 1)
        return [[sorted objectAtIndex:count / 2 - 1] doubleValue];
    
    return ([[sorted objectAtIndex:count / 2 - 1] doubleValue] + [[sorted objectAtIndex:count / 2] doubleValue]) / 2;
}

@end
