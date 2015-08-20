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
}

#pragma mark Tests

- (void)testCount {
    XCTAssertEqual(stat.count, (NSUInteger) 0);

    [stat addData:@"1"];
    [stat addData:@"2"];
    XCTAssertEqual(stat.count, (NSUInteger)2);

    [stat addData:@"2"];
    XCTAssertEqual(stat.count, (NSUInteger)3);
}

- (void)testMin {
    [stat addData:@"1"];
    [stat addData:@"2"];
    XCTAssertEqualWithAccuracy(stat.min, 1.0, 1e-6);
    
    [stat addData:@"-2"];
    XCTAssertEqualWithAccuracy(stat.min, -2.0, 1e-6);
}

- (void)testMindex {
    [stat addData:@"1"];
    [stat addData:@"2"];
    XCTAssertEqual(stat.mindex, (NSUInteger)0);
    
    [stat addData:@"-2"];
    XCTAssertEqual(stat.mindex, (NSUInteger)2);
}

- (void)testMax {
    [stat addData:@"1"];
    [stat addData:@"2"];
    XCTAssertEqualWithAccuracy(stat.max, 2.0, 1e-6);

    [stat addData:@"-3"];
    XCTAssertEqualWithAccuracy(stat.max, 2.0, 1e-6);
}

- (void)testMaxdex {
    [stat addData:@"1"];
    [stat addData:@"2"];
    XCTAssertEqual(stat.maxdex, (NSUInteger)1);
    
    [stat addData:@"-3"];
    XCTAssertEqual(stat.maxdex, (NSUInteger)1);
}

- (void)testMean {
    [stat addData:@"1"];
    [stat addData:@"2"];
    XCTAssertEqualWithAccuracy(stat.mean, 3/2.0, 1e-6);

    [stat addData:@"-2"];
    XCTAssertEqualWithAccuracy(stat.mean, 1/3.0, 1e-6);
}

- (void)testRange {
    [stat addData:@"19"];
    XCTAssertEqualWithAccuracy([stat range], 0.0, 1e-6);
    XCTAssertEqualWithAccuracy(stat.range, 0.0, 1e-6);

    [stat addData:@"2"];
    XCTAssertEqualWithAccuracy([stat range], 17.0, 1e-6);
    XCTAssertEqualWithAccuracy(stat.range, 17.0, 1e-6);
    
    [stat addData:@"-2"];
    XCTAssertEqualWithAccuracy([stat range], 21.0, 1e-6);
    XCTAssertEqualWithAccuracy(stat.range, 21.0, 1e-6);   
}

- (void)testVariance {
    [stat addDataFromArray:[@"1 2 3 4" componentsSeparatedByString:@" "]];
    XCTAssertEqualWithAccuracy([stat variance], 5/3.0, 1e-6);
}

- (void)testStandardDeviation {
    [stat addDataFromArray:[@"1 2 3 4" componentsSeparatedByString:@" "]];
    XCTAssertEqualWithAccuracy([stat standardDeviation], sqrt(5/3.0), 1e-6);
    
}

- (void)testBiasedVariance {
    [stat addDataFromArray:[@"1 2 3 4" componentsSeparatedByString:@" "]];
    XCTAssertEqualWithAccuracy([stat biasedVariance], 5/4.0, 1e-6);
}

- (void)testBiasedStandardDeviation {
    [stat addDataFromArray:[@"1 2 3 4" componentsSeparatedByString:@" "]];
    XCTAssertEqualWithAccuracy([stat biasedStandardDeviation], sqrt(5/4.0), 1e-6);    
}

@end
