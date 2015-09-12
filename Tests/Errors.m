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
}

#pragma mark SBStatistics

- (void)testMin {
    XCTAssertTrue(isnan(stat.min));
    [stat addData:@"2"];
    XCTAssertFalse(isnan(stat.min));
}

- (void)testMax {
    XCTAssertTrue(isnan(stat.max));
    [stat addData:@"2"];
    XCTAssertFalse(isnan(stat.max));
}

- (void)testMean {
    XCTAssertTrue(isnan(stat.mean));
    [stat addData:@"2"];
    XCTAssertFalse(isnan(stat.mean));
}

- (void)testRange {
    XCTAssertTrue(isnan([stat range]));    
    [stat addData:@"2"];
    XCTAssertFalse(isnan(stat.range));
}

- (void)testVariance {
    XCTAssertTrue(isnan([stat variance]));
    XCTAssertTrue(isnan([stat biasedVariance]));
    
    [stat addData:@"2"];
    XCTAssertTrue(isnan([stat variance]));
    XCTAssertTrue(isnan([stat biasedVariance]));
}

- (void)testStandardDeviation {
    XCTAssertTrue(isnan([stat standardDeviation]));
    XCTAssertTrue(isnan([stat biasedStandardDeviation]));
    
    [stat addData:@"2"];
    XCTAssertTrue(isnan([stat standardDeviation]));
    XCTAssertTrue(isnan([stat biasedStandardDeviation]));
}

#pragma mark SBFullStatistics

- (void)testMode {
    XCTAssertTrue(isnan([stat mode]));
    [stat addData:@"1"];
    XCTAssertTrue(isnan([stat mode]));
    [stat addData:@"-1"];
    XCTAssertTrue(isnan([stat mode]));
    [stat addData:@"-1"];
    XCTAssertFalse(isnan([stat mode]));
}

- (void)testMedian {
    XCTAssertTrue(isnan([stat median]));
    [stat addData:@"1"];
    XCTAssertFalse(isnan([stat median]));
}

- (void)testFrequencyDistributionWithBuckets {
    id buckets = [@"1 20" componentsSeparatedByString:@" "];
    id expected = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithInt:0], [NSNumber numberWithInt:1],
                   [NSNumber numberWithInt:0], [NSNumber numberWithInt:20],
                   nil];
    XCTAssertEqualObjects([stat frequencyDistributionWithBuckets:buckets cumulative:NO], expected);

    XCTAssertThrows([stat frequencyDistributionWithBuckets:nil cumulative:NO]);
    XCTAssertThrows([stat frequencyDistributionWithBuckets:[NSArray array] cumulative:NO]);
}

- (void)testHarmonicMean {
    XCTAssertTrue(isnan([stat harmonicMean]));

    [stat addData:@"1"];
    XCTAssertFalse(isnan([stat harmonicMean]));

    [stat addData:@"0"];
    XCTAssertTrue(isnan([stat harmonicMean]));
}

- (void)testGeometricMean {
    XCTAssertTrue(isnan([stat geometricMean]));
    
    [stat addData:@"1"];
    XCTAssertFalse(isnan([stat geometricMean]));

    [stat addData:@"0"];
    XCTAssertFalse(isnan([stat geometricMean]));

    [stat addData:@"-1"];
    XCTAssertTrue(isnan([stat geometricMean]));
}

- (void)testBuckets {
    XCTAssertNil([stat bucketsWithCount:1]);
}

@end
