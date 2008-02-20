//
//  SBFullStatistics.m
//  Statistics
//
//  Created by Stig Brautaset on 10/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import "SBStatistics.h"
#import "SBMutableDictionary.h"


@implementation SBFullStatistics

- (id)init
{
    if (self = [super init]) {
        data = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [data release];
    [sortedData release];
    [super dealloc];
}

#pragma mark Adding data

- (void)addData:(id)x
{
    if (![x isKindOfClass:[NSNumber class]])
        x = [NSNumber numberWithDouble:[x doubleValue]];
    [super addData:x];
    [data addObject:x];
    
    // Invalidate cached data
    [sortedData release];
    sortedData = nil;
}

#pragma mark Returning data

- (NSArray*)data
{
    return [[data copy] autorelease];
}

- (NSArray*)sortedData
{
    // Do we have cached sorted data? use it
    if (sortedData)
        return [[sortedData retain] autorelease];
    return sortedData = [[data sortedArrayUsingSelector:@selector(compare:)] retain];
}

#pragma mark Statistics

- (double)mode
{
    id freq = [NSMutableDictionary dictionaryWithCapacity:count];
    for (NSNumber *x in data)
        [freq incrementValueForNumber:x];

    // No mode exists if all the numbers are unique
    if ([freq count] == count)
        return nan(0);
    return [[[freq keysSortedByValueUsingSelector:@selector(compare:)] lastObject] doubleValue];
}

- (double)median
{
    if (!count)
        return nan(0);
    if (count == 1)
        return [[data lastObject] doubleValue];
    
    NSArray *sorted = [self sortedData];
    if (count & 1)
        return [[sorted objectAtIndex:count / 2 - 1] doubleValue];    
    return ([[sorted objectAtIndex:count / 2 - 1] doubleValue] + [[sorted objectAtIndex:count / 2] doubleValue]) / 2;
}

- (NSDictionary*)frequencyDistributionWithPartitions:(NSUInteger)x
{
    // Must have at least one partition, and at least one data point
    if (!x || !count)
        return nil;
    
    // Calculate the interval of each bucket
    double interval = self.range / x;

    // Create the buckets
    id buckets = [NSMutableArray arrayWithObject:[NSNumber numberWithDouble:max]];
    for (double bucket = self.max - interval; bucket > self.min; bucket -= interval)
        [buckets addObject:[NSNumber numberWithDouble:bucket]];
    
    return [self frequencyDistributionWithBuckets:buckets];
}

- (NSDictionary*)frequencyDistributionWithBuckets:(NSArray*)x
{
    NSAssert([x count], @"No buckets given");

    // Buckets must be NSNumbers
    id buckets = [NSMutableArray arrayWithCapacity:[x count]];
    for (id b in x)
        [buckets addObject:[NSNumber numberWithDouble:[b doubleValue]]];
    
    // Create dictionary to hold frequency distribution and initialise each bucket
    id freq = [NSMutableDictionary dictionaryWithCapacity:[buckets count]];
    for (NSNumber *bucket in buckets)
        [freq setObject:[NSNumber numberWithInt:0] forKey:bucket];

    // Make sure the buckets are sorted, and prepare an iterator for them
    buckets = [buckets sortedArrayUsingSelector:@selector(compare:)];
    NSEnumerator *biter = [buckets objectEnumerator];
    NSNumber *b = [biter nextObject];

    // Determine the frequency for each bucket    
    for (NSNumber *n in [self sortedData]) {
    again:
        if ([n compare:b] <= 0) {
            [freq incrementValueForNumber:b];
        } else {
            b = [biter nextObject];
            if (b)
                goto again;
        }
    }

    return freq;
}

- (double)trimmedMeanWithPercentile:(double)x
{
    NSAssert1(x > 0 && x < 1.0, @"Percentile must be 0 < x < 1, was %u", x);
    return [self trimmedMeanWithHighPercentile:x low:x];
}

- (double)trimmedMeanWithHighPercentile:(double)x low:(double)y
{
    NSAssert1(x >= 0 && x <= 1.0, @"High percentile must be 0 <= x <= 1, was %u", x);
    NSAssert1(y >= 0 && y <= 1.0, @"Low percentile must be 0 <= x <= 1, was %u", y);

    NSUInteger hibound = x * count;
    NSUInteger lobound = y * count;
    if (!hibound && !lobound)
        return self.mean;
    
    id trimmed = [[self sortedData] subarrayWithRange:NSMakeRange(lobound, count-hibound-1)];
    
    double trimmedMean = 0.0;
    NSUInteger i = 0;
    for (NSNumber *n in trimmed)
        trimmedMean += ([n doubleValue] - trimmedMean) / ++i;
    return trimmedMean;
}

- (double)harmonicMean
{
    long double sum = 0.0;
    for (NSNumber *n in data) {
        double d = [n doubleValue];
        if (d == 0)
            return nan(0);
        sum += 1 / d;
    }
    return count / sum;
}

- (double)geometricMean
{
    long double sum = 1;
    for (NSNumber *n in data) {
        double d = [n doubleValue];
        if (d < 0)
            return nan(0);
        sum *= d;
    }
    return count ? pow(sum, 1.0 / count) : nan(0);
}

@end
