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
    for (id x in data)
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

@end
