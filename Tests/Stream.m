//
//  Statistics.m
//  Statistics
//
//  Created by Stig Brautaset on 09/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import "Tests.h"
#import <Statistics/Statistics.h>


@implementation Stream

#pragma mark Setup / Teardown

- (void)setUp {
    stat = [SBStatistics new];
}

- (void)tearDown {
    [stat release];
}

#pragma mark Tests

- (void)testCount {
    STAssertEquals(stat.count, (NSUInteger) 0, nil);

    [stat addData:@"1"];
    [stat addData:@"2"];
    STAssertEquals(stat.count, (NSUInteger)2, nil);

    [stat addData:@"2"];
    STAssertEquals(stat.count, (NSUInteger)3, nil);
}

- (void)testMin {
    [stat addData:@"1"];
    [stat addData:@"2"];
    STAssertEqualsWithAccuracy(stat.min, 1.0, 1e-6, nil);
    
    [stat addData:@"-2"];
    STAssertEqualsWithAccuracy(stat.min, -2.0, 1e-6, nil);
}

- (void)testMindex {
    [stat addData:@"1"];
    [stat addData:@"2"];
    STAssertEquals(stat.mindex, (NSUInteger)0, nil);
    
    [stat addData:@"-2"];
    STAssertEquals(stat.mindex, (NSUInteger)2, nil);
}

- (void)testMax {
    [stat addData:@"1"];
    [stat addData:@"2"];
    STAssertEqualsWithAccuracy(stat.max, 2.0, 1e-6, nil);

    [stat addData:@"-3"];
    STAssertEqualsWithAccuracy(stat.max, 2.0, 1e-6, nil);
}

- (void)testMaxdex {
    [stat addData:@"1"];
    [stat addData:@"2"];
    STAssertEquals(stat.maxdex, (NSUInteger)1, nil);
    
    [stat addData:@"-3"];
    STAssertEquals(stat.maxdex, (NSUInteger)1, nil);
}

- (void)testMean {
    [stat addData:@"1"];
    [stat addData:@"2"];
    STAssertEqualsWithAccuracy(stat.mean, 3/2.0, 1e-6, nil);

    [stat addData:@"-2"];
    STAssertEqualsWithAccuracy(stat.mean, 1/3.0, 1e-6, nil);
}

- (void)testRange {
    [stat addData:@"19"];
    STAssertEqualsWithAccuracy([stat range], 0.0, 1e-6, nil);
    STAssertEqualsWithAccuracy(stat.range, 0.0, 1e-6, nil);

    [stat addData:@"2"];
    STAssertEqualsWithAccuracy([stat range], 17.0, 1e-6, nil);
    STAssertEqualsWithAccuracy(stat.range, 17.0, 1e-6, nil);
    
    [stat addData:@"-2"];
    STAssertEqualsWithAccuracy([stat range], 21.0, 1e-6, nil);
    STAssertEqualsWithAccuracy(stat.range, 21.0, 1e-6, nil);   
}

- (void)testVariance {
    [stat addDataFromArray:[@"1 2 3 4" componentsSeparatedByString:@" "]];
    STAssertEqualsWithAccuracy([stat variance], 5/3.0, 1e-6, nil);
}

- (void)testStandardDeviation {
    [stat addDataFromArray:[@"1 2 3 4" componentsSeparatedByString:@" "]];
    STAssertEqualsWithAccuracy([stat standardDeviation], sqrt(5/3.0), 1e-6, nil);
    
}

- (void)testBiasedVariance {
    [stat addDataFromArray:[@"1 2 3 4" componentsSeparatedByString:@" "]];
    STAssertEqualsWithAccuracy([stat biasedVariance], 5/4.0, 1e-6, nil);
}

- (void)testBiasedStandardDeviation {
    [stat addDataFromArray:[@"1 2 3 4" componentsSeparatedByString:@" "]];
    STAssertEqualsWithAccuracy([stat biasedStandardDeviation], sqrt(5/4.0), 1e-6, nil);    
}

@end
