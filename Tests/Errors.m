//
//  Errors.m
//  Statistics
//
//  Created by Stig Brautaset on 17/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import "Tests.h"
#import <Statistics/Statistics.h>


@implementation Errors

#pragma mark Setup / Teardown

- (void)setUp {
    stat = [SBFullStatistics new];
}

- (void)tearDown {
    [stat release];
}

#pragma mark Tests

- (void)testMin {
    STAssertTrue(isnan(stat.min), nil);
    [stat addData:@"2"];
    STAssertFalse(isnan(stat.min), nil);
}

- (void)testMax {
    STAssertTrue(isnan(stat.max), nil);
    [stat addData:@"2"];
    STAssertFalse(isnan(stat.max), nil);
}

- (void)testMean {
    STAssertTrue(isnan(stat.mean), nil);
    [stat addData:@"2"];
    STAssertFalse(isnan(stat.mean), nil);
}

- (void)testRange {
    STAssertTrue(isnan([stat range]), nil);    
    [stat addData:@"2"];
    STAssertFalse(isnan(stat.range), nil);
}

- (void)testVariance {
    STAssertTrue(isnan([stat variance]), nil);
    STAssertTrue(isnan([stat biasedVariance]), nil);
    
    [stat addData:@"2"];
    STAssertTrue(isnan([stat variance]), nil);
    STAssertTrue(isnan([stat biasedVariance]), nil);
}

- (void)testStandardDeviation {
    STAssertTrue(isnan([stat standardDeviation]), nil);
    STAssertTrue(isnan([stat biasedStandardDeviation]), nil);
    
    [stat addData:@"2"];
    STAssertTrue(isnan([stat standardDeviation]), nil);
    STAssertTrue(isnan([stat biasedStandardDeviation]), nil);
}

- (void)testFrequencyDistribution {
    STAssertEqualObjects([stat frequencyDistributionWithPartitions:3], [NSDictionary dictionary], nil);

    id buckets = [@"1 20" componentsSeparatedByString:@" "];
    id expected = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithInt:0], [NSNumber numberWithInt:1],
                   [NSNumber numberWithInt:0], [NSNumber numberWithInt:20],
                   nil];
    STAssertEqualObjects([stat frequencyDistributionWithBuckets:buckets], expected, nil);
}

@end
