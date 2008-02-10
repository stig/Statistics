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
        [buckets insertObject:[NSNumber numberWithDouble:bucket] atIndex:0];
    
    // Create dictionary to hold frequency distribution and initialise each bucket
    id freq = [NSMutableDictionary dictionaryWithCapacity:x];
    for (NSNumber *bucket in buckets)
        [freq setObject:[NSNumber numberWithInt:0] forKey:bucket];
    

    // Now determine the frequency for each bucket
    for (NSNumber *n in data)
        for (NSNumber *b in buckets)
            if ([b compare:n] >= 0) {
                [freq incrementValueForNumber:b];
                break;
            }

    return freq;
}

@end
