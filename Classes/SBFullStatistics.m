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

- (id)statisticsDiscardingLow:(double)l high:(double)h
{
    id copy = [[self class] new];
    [copy addDataFromArray:[self sortedDataDiscardingLow:l high:h]];
    return [copy autorelease];
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
        return self.mean;
    
    NSArray *sorted = [self sortedData];
    if (count & 1)
        return [[sorted objectAtIndex:count / 2 - 1] doubleValue];    
    return ([[sorted objectAtIndex:count / 2 - 1] doubleValue] + [[sorted objectAtIndex:count / 2] doubleValue]) / 2;
}

- (double)percentile:(double)x
{
    NSAssert1(x >= 0 && x <= 1, @"Percentile must be 0 <= x <= 1, but was %f", x);
    NSUInteger i = (count-1) * x;
    return [[[self sortedData] objectAtIndex:i] doubleValue];
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

- (NSArray*)bucketsWithCount:(NSUInteger)x
{
    return [self bucketsWithInterval:self.range / x];
}

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
