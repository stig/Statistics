//
//  SBStatistics.m
//  Statistics
//
//  Created by Stig Brautaset on 10/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import "SBStatistics.h"


@implementation SBStatistics

@synthesize count;
@synthesize mindex;
@synthesize maxdex;

@synthesize min;
@synthesize max;
@synthesize mean;

- (id)init
{
    if (self = [super init]) {
        count = 0;
        min = INFINITY;
        max = -INFINITY;
    }
    return self;
}

- (void)addDataFromArray:(NSArray*)array
{
    for (id x in array)
        [self addData:x];
}

- (void)addData:(id)x
{
    NSAssert([x respondsToSelector:@selector(doubleValue)], @"Data must respond to -doubleValue");
    
    double d = [x doubleValue];
    if (d < min) {
        min = d;
        mindex = count;
    } else if (d > max) {
        max = d;
        maxdex = count;
    }
    count++;    
    
    double oldMean = mean;

    mean += (d - oldMean) / count;
    pseudoVariance += (d - mean) * (d - oldMean);
}

- (double)range
{
    return max - min;
}

- (double)variance
{
    return pseudoVariance / (count - 1);
}

- (double)biasedVariance
{
    return pseudoVariance / count;    
}

- (double)standardDeviation
{
    return sqrt([self variance]);
}

- (double)biasedStandardDeviation
{
    return sqrt([self biasedVariance]);
}

/*
- (double)median
{
    NSAssert([self count], nil);
    
    NSUInteger count = [self count];
    NSArray *sorted = [self sortedArrayUsingSelector:@selector(compare:)];
    if (count & 1)
        return [[sorted objectAtIndex:count / 2 - 1] doubleValue];
    
    return ([[sorted objectAtIndex:count / 2 - 1] doubleValue] + [[sorted objectAtIndex:count / 2] doubleValue]) / 2;
}

 */
@end
