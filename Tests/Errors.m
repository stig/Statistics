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
}

- (void)testMax {
    STAssertTrue(isnan(stat.max), nil);
}

- (void)testMean {
    STAssertTrue(isnan(stat.mean), nil);
}

- (void)testRange {
    STAssertTrue(isnan([stat range]), nil);    
}

- (void)testVariance {
    STAssertTrue(isnan([stat variance]), nil);
}

- (void)testStandardDeviation {
    STAssertTrue(isnan([stat standardDeviation]), nil);
}


@end
