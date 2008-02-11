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
    [super dealloc];
}

#pragma mark Adding data

- (void)addData:(id)x
{
    if (![x isKindOfClass:[NSNumber class]])
        x = [NSNumber numberWithDouble:[x doubleValue]];
    [super addData:x];
    [data addObject:x];
}

#pragma mark Statistics

- (double)mode
{
    id freq = [NSMutableDictionary dictionaryWithCapacity:count];
    for (NSNumber *x in data)
        [freq incrementValueForNumber:x];
    return [[[freq keysSortedByValueUsingSelector:@selector(compare:)] lastObject] doubleValue];
}

- (double)median
{
    NSArray *sorted = [data sortedArrayUsingSelector:@selector(compare:)];
    if (count & 1)
        return [[sorted objectAtIndex:count / 2 - 1] doubleValue];    
    return ([[sorted objectAtIndex:count / 2 - 1] doubleValue] + [[sorted objectAtIndex:count / 2] doubleValue]) / 2;
}

- (NSDictionary*)frequencyDistributionWithPartitions:(NSUInteger)x
{
    // Calculate the range of each bucket
    double interval = self.range / x;

    // Create the buckets
    id buckets = [NSMutableArray arrayWithCapacity:x];
    for (double bucket = self.max; bucket > self.min; bucket -= interval)
        [buckets addObject:[NSNumber numberWithDouble:bucket]];
    
    return [self frequencyDistributionWithBuckets:buckets];
}

- (NSDictionary*)frequencyDistributionWithBuckets:(NSArray*)x
{
    // Buckets must be NSNumbers
    id buckets = [NSMutableArray arrayWithCapacity:[x count]];
    for (id b in x)
        [buckets addObject:[NSNumber numberWithDouble:[b doubleValue]]];
                               
    // Make sure the buckets are sorted
    buckets = [buckets sortedArrayUsingSelector:@selector(compare:)];
    
    // Create dictionary to hold frequency distribution and initialise each bucket
    id freq = [NSMutableDictionary dictionaryWithCapacity:[buckets count]];
    for (NSNumber *bucket in buckets)
        [freq setObject:[NSNumber numberWithInt:0] forKey:bucket];
    
    // Determine the frequency for each bucket
    for (NSNumber *n in data)
        for (NSNumber *b in buckets)
            if ([b compare:n] >= 0) {
                [freq incrementValueForNumber:b];
                break;
            }
    
    return freq;
}

- (double)trimmedMeanWithPercentile:(double)x
{
    NSAssert(x > 0 && x < 1.0, @"Contract violation");
    
    NSUInteger bound = x * count;
    if (!bound || bound == count)
        return self.mean;
    
    id sorted = [data sortedArrayUsingSelector:@selector(compare:)];
    id trimmed = [sorted subarrayWithRange:NSMakeRange(bound, count-bound-1)];
    
    double trimmedMean = 0.0;
    NSUInteger i = 0;
    for (NSNumber *n in trimmed)
        trimmedMean += ([n doubleValue] - trimmedMean) / ++i;
    return trimmedMean;
}

@end
