//
//  SBFullStatistics.m
//  Statistics
//
//  Created by Stig Brautaset on 10/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import "SBStatistics.h"
#import "SBMutableDictionary.h"

/// Instances of this class keeps a copy of each data point and is
/// thereby able to produce sophisticated statistics. It can
/// (eventually) take up very much memory if you collect a lot of data.
/// @see SBStatistics
@implementation SBFullStatistics

#pragma mark Creation and deletion

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

/// This can be used to calculate the truncated (trimmed) mean,
/// or any other trimmed value you might care to know.
/// @see http://en.wikipedia.org/wiki/Truncated_mean
/// @param l should be a real number such that 0 <= l < 1.
/// @param h should be a real number such that 0 <= h < 1.
- (id)statisticsDiscardingLow:(double)l high:(double)h
{
    id copy = [[self class] new];
    [copy addDataFromArray:[self sortedDataDiscardingLow:l high:h]];
    return [copy autorelease];
}

#pragma mark Adding data

/// Overrides the superclass' method to store each data point.
/// Also invalidates the cached sorted data, if any.
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

/// Returns an autoreleased copy of the data array.
- (NSArray*)data
{
    return [[data copy] autorelease];
}

/// This is used by several other methods. The result is cached until
/// the next time addData: is called.
- (NSArray*)sortedData
{
    // Do we have cached sorted data? use it
    if (sortedData)
        return [[sortedData retain] autorelease];
    return sortedData = [[data sortedArrayUsingSelector:@selector(compare:)] retain];
}

/// The parameters l=0.05 and h=0.1 means discarding the lower 5% and
/// upper 10% of the data.
/// @param l should be a real number such that 0 <= l < 1.
/// @param h should be a real number such that 0 <= h < 1.
- (NSArray*)sortedDataDiscardingLow:(double)l high:(double)h
{
    NSAssert1(l >= 0 && l < 1.0, @"Low bound must be 0 <= x < 1, was %f", l);
    NSAssert1(h >= 0 && h < 1.0, @"High bound must be 0 <= x < 1, was %f", h);
    
    NSUInteger lo = l * count;
    NSUInteger hi = ceil(count - h * count);
    NSRange r = NSMakeRange(lo, hi - lo);

    return [[self sortedData] subarrayWithRange:r];
}

#pragma mark Statistics

/// Returns the most frequently occuring data point, or nan if all the
/// data points are unique. If there are multiple candidates it is
/// undefined which one is returned.
/// @see http://en.wikipedia.org/wiki/Mode_(statistics)
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

/// @see http://en.wikipedia.org/wiki/Median
- (double)median
{
    if (!count)
        return nan(0);
    if (count == 1)
        return self.mean;
    
    NSArray *sorted = [self sortedData];
    if (count & 1)
        return [[sorted objectAtIndex:count / 2 - 1] doubleValue];    
    return ([[sorted objectAtIndex:count / 2 - 1] doubleValue] + [[sorted objectAtIndex:count / 2] doubleValue]) / 2;
}

/// @param x should be a real number such that 0 <= x <= 1.
/// @see http://en.wikipedia.org/wiki/Percentile
- (double)percentile:(double)x
{
    NSAssert1(x >= 0 && x <= 1, @"Percentile must be 0 <= x <= 1, but was %f", x);
    NSUInteger i = (count-1) * x;
    return [[[self sortedData] objectAtIndex:i] doubleValue];
}

/// The harmonic mean is undefined if any of the data points are zero,
/// and this method will return nan in that case.
/// @see http://en.wikipedia.org/wiki/Harmonic_mean
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

/// The geometric mean is undefined if any data point is less than
/// zero, and this method returns nan in that case. Also returns nan()
/// if called before any data has been added.
/// @see http://en.wikipedia.org/wiki/Geometric_mean
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

/// @param buckets An array of buckets to partition the data into
/// @param cumulative Whether to return the cumulative frequency distribution
/// @see http://en.wikipedia.org/wiki/Frequency_distribution
/// @see bucketsWithCount:
/// @see bucketsWithInterval:
- (NSDictionary*)frequencyDistributionWithBuckets:(NSArray*)x cumulative:(BOOL)cumulative
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

    if (cumulative) {
        NSUInteger total = 0;
        id cfreq = [NSMutableDictionary dictionaryWithCapacity:[buckets count]];
        for (id key in buckets) {
            total += [[freq objectForKey:key] unsignedIntValue];
            [cfreq setObject:[NSNumber numberWithUnsignedInteger:total] forKey:key];
        }
        freq = cfreq;
    }
    
    return freq;
}

#pragma mark Buckets

/// The highest bucket will be equal to max of the population
- (NSArray*)bucketsWithCount:(NSUInteger)x
{
    return [self bucketsWithInterval:self.range / x];
}

/// The highest bucket will be equal to max of the population
- (NSArray*)bucketsWithInterval:(double)interval
{
    if (interval > 0) {
        id buckets = [NSMutableArray arrayWithObject:[NSNumber numberWithDouble:max]];
        for (double bucket = self.max - interval; bucket > self.min; bucket -= interval)
            [buckets addObject:[NSNumber numberWithDouble:bucket]];
        return buckets;
    }
    return nil;
}


@end
