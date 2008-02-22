//
//  SBStatistics.m
//  Statistics
//
//  Created by Stig Brautaset on 10/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import "SBStatistics.h"


/// This class doesn't keep any of the data points, so uses hardly any
/// memory. On the other hand it isn't able to compute the more
/// complex statistics.
/// @see SBFullStatistics
@implementation SBStatistics

@synthesize count;
@synthesize mindex;
@synthesize maxdex;

@synthesize min;
@synthesize max;
@synthesize mean;

#pragma mark Initialisation

- (id)init
{
    if (self = [super init]) {
        min = max = mean = nan(0);
    }
    return self;
}

#pragma mark Adding data

/// @see addData:
- (void)addDataFromArray:(NSArray*)array
{
    for (id x in array)
        [self addData:x];
}

/// This method does most of the work, including computing the stats.
/// @param x must respond to -doubleValue.
- (void)addData:(id)x
{
    NSAssert([x respondsToSelector:@selector(doubleValue)], @"Data must respond to -doubleValue");
    
    double d = [x doubleValue];

    if (!count) {
        min = INFINITY;
        max = -min;
        mean = 0;
    }
    
    if (d < min) {
        min = d;
        mindex = count;
    }
    if (d > max) {
        max = d;
        maxdex = count;
    }
    
    double oldMean = mean;
    mean += (d - oldMean) / ++count;
    pseudoVariance += (d - mean) * (d - oldMean);
}

#pragma mark Methods

- (double)range
{
    return max - min;
}

/// @see http://en.wikipedia.org/wiki/Variance
- (double)variance
{
    if (count > 1)
        return pseudoVariance / (count - 1);
    return nan(0);
}

/// @see variance
- (double)biasedVariance
{
    if (count > 1)
        return pseudoVariance / count;
    return nan(0);
}

/// @see http://en.wikipedia.org/wiki/Standard_deviation
- (double)standardDeviation
{
    return sqrt([self variance]);
}

/// @see standardDeviation
- (double)biasedStandardDeviation
{
    return sqrt([self biasedVariance]);
}

@end
