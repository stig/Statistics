//
//  Full.m
//  Statistics
//
//  Created by Stig Brautaset on 10/02/2008.
//  Copyright 2008 Stig Brautaset. All rights reserved.
//

#import "Tests.h"
#import <Statistics/Statistics.h>

#define num(n) [NSNumber numberWithDouble:n]
#define keyval(k, v) [NSNumber numberWithDouble:v], [NSNumber numberWithDouble:k]


@implementation Full

#pragma mark Setup / Teardown

- (void)setUp {
    stat = [SBFullStatistics new];
}

- (void)tearDown {
}


#pragma mark Tests

- (void)testMode {
    [stat addDataFromArray:[@"9 3.3 1 2 2" componentsSeparatedByString:@" "]];
    XCTAssertEqualWithAccuracy([stat mode], 2.0, 1e-6);
    
    [stat addDataFromArray:[@"4 4 4" componentsSeparatedByString:@" "]];
    XCTAssertEqualWithAccuracy([stat mode], 4.0, 1e-6);

    // Ensure string/number agnosticism
    [stat addData:[NSNumber numberWithInt:2]];
    [stat addData:[NSNumber numberWithInt:2]];
    XCTAssertEqualWithAccuracy([stat mode], 2.0, 1e-6);
}

- (void)testMedian {
     [stat addDataFromArray:[@"9 3.3 1 2 2" componentsSeparatedByString:@" "]];
     XCTAssertEqualWithAccuracy([stat median], 2.0, 1e-6);
 
     [stat addData:@"4"];
     XCTAssertEqualWithAccuracy([stat median], (3.3 + 2)/2, 1e-6);
 
     [stat addData:@"-4"];
     [stat addData:@"-4"];
     XCTAssertEqualWithAccuracy([stat median], 2.0, 1e-6);
}

- (void)testPercentile {
    [stat addDataFromArray:[@"6 7 8 16 0 1 2 3 4 5" componentsSeparatedByString:@" "]];
    XCTAssertEqualWithAccuracy([stat percentile:0.0], stat.min, 1e-6);
    XCTAssertEqualWithAccuracy([stat percentile:1.0], stat.max, 1e-6);

    XCTAssertEqualWithAccuracy([stat percentile:0.05], stat.min, 1e-6);
    XCTAssertEqualWithAccuracy([stat percentile:0.25], 2.0, 1e-6);

    XCTAssertEqualWithAccuracy([stat percentile:0.95], 8.0, 1e-6);
    XCTAssertEqualWithAccuracy([stat percentile:0.975], 8.0, 1e-6);
}

- (void)testHarmonicMean {
    [stat addDataFromArray:[@"8 9 10" componentsSeparatedByString:@" "]];
    XCTAssertEqualWithAccuracy([stat harmonicMean], 8.926, 1e-3);
}

- (void)testGeometricMean {
    [stat addDataFromArray:[@"1 0.5 0.25" componentsSeparatedByString:@" "]];
    XCTAssertEqualWithAccuracy([stat geometricMean], 0.5, 1e-6);
}

- (void)testFrequencyDistributionBuckets {
    [stat addDataFromArray:[@"9 3.3 1 5 2" componentsSeparatedByString:@" "]];
    id expect = [NSArray arrayWithObjects:num(9), num(5), nil];
    XCTAssertEqualObjects([stat bucketsWithCount:2], expect);

    id expect2 = [NSArray arrayWithObjects:num(9), num(7), num(5), num(3), nil];
    XCTAssertEqualObjects([stat bucketsWithCount:4], expect2);
    
    // Now add a negative number.
    [stat addDataFromArray:[@"-9" componentsSeparatedByString:@" "]];
    id expect3 = [NSArray arrayWithObjects:num(9), num(4.5), num(0), num(-4.5), nil];
    XCTAssertEqualObjects([stat bucketsWithCount:4], expect3);
}

- (void)testFrequencyDistribution {
    [stat addDataFromArray:[@"9 3.3 1 5 2" componentsSeparatedByString:@" "]];
    id expect = [NSDictionary dictionaryWithObjectsAndKeys:
                 keyval(9, 1),
                 keyval(5, 4),
                 nil];
    XCTAssertEqualObjects([stat frequencyDistributionWithBuckets:[stat bucketsWithCount:2] cumulative:NO], expect);

    id expect2 = [NSDictionary dictionaryWithObjectsAndKeys:
                  keyval(9, 1),
                  keyval(7, 0),
                  keyval(5, 2),
                  keyval(3, 2),
                  nil];
    XCTAssertEqualObjects([stat frequencyDistributionWithBuckets:[stat bucketsWithCount:4] cumulative:NO], expect2);
    
    // Now add a negative number.
    [stat addDataFromArray:[@"-9" componentsSeparatedByString:@" "]];
    id expect3 = [NSDictionary dictionaryWithObjectsAndKeys:
                  keyval(9, 2),
                  keyval(4.5, 3),
                  keyval(0, 0),
                  keyval(-4.5, 1),
                  nil];
    XCTAssertEqualObjects([stat frequencyDistributionWithBuckets:[stat bucketsWithCount:4] cumulative:NO], expect3);
}

- (void)testFrequencyDistributionCumulative {
    [stat addDataFromArray:[@"9 3.3 1 5 2" componentsSeparatedByString:@" "]];
    id expect = [NSDictionary dictionaryWithObjectsAndKeys:
                 keyval(9, 5),
                 keyval(5, 4),
                 nil];
    XCTAssertEqualObjects([stat frequencyDistributionWithBuckets:[stat bucketsWithCount:2] cumulative:YES], expect);
    
    id expect2 = [NSDictionary dictionaryWithObjectsAndKeys:
                  keyval(9, 5),
                  keyval(7, 4),
                  keyval(5, 4),
                  keyval(3, 2),
                  nil];
    XCTAssertEqualObjects([stat frequencyDistributionWithBuckets:[stat bucketsWithCount:4] cumulative:YES], expect2);
    
    // Now add a negative number.
    [stat addDataFromArray:[@"-9" componentsSeparatedByString:@" "]];
    id expect3 = [NSDictionary dictionaryWithObjectsAndKeys:
                  keyval(9, 6),
                  keyval(4.5, 4),
                  keyval(0, 1),
                  keyval(-4.5, 1),
                  nil];
    XCTAssertEqualObjects([stat frequencyDistributionWithBuckets:[stat bucketsWithCount:4] cumulative:YES], expect3);
}

- (void)testFrequencyDistributionPerformance {
    int n = 1e5;
    int i;
    for (i = 0; i < n; i++)
        [stat addData:[NSNumber numberWithInt:random()]];
    
    id start = [NSDate date];
    [stat frequencyDistributionWithBuckets:[stat bucketsWithCount:n/100] cumulative:NO];
    XCTAssertTrue(-[start timeIntervalSinceNow] < 3.0, @"Should be quick");
}

- (void)testSortedDataDiscarding {
    [stat addDataFromArray:[@"6 7 8 9 0 1 2 3 4 5" componentsSeparatedByString:@" "]];

    XCTAssertEqual([[stat sortedDataDiscardingLowOutliers:0.05 high:0.05] count], (NSUInteger)10);
    XCTAssertEqual([[stat sortedDataDiscardingLowOutliers:0.1 high:0.1] count], (NSUInteger)8);
    XCTAssertEqual([[stat sortedDataDiscardingLowOutliers:0.2 high:0.2] count], (NSUInteger)6);

    NSArray *sub = [stat sortedDataDiscardingLowOutliers:0.3 high:0.4];
    XCTAssertEqual([[sub objectAtIndex:0] intValue], (int)3);
    XCTAssertEqual([[sub lastObject] intValue], (int)5);
}

#pragma mark Derived Statistics

- (void)testTrimmedMean {
    [stat addDataFromArray:[@"0 15 15 15 35" componentsSeparatedByString:@" "]];
    SBFullStatistics *s;
    
    s = [stat statisticsDiscardingLowOutliers:0.0 high:0.4];
    XCTAssertEqualWithAccuracy([s mean], 10.0, 1e-6);
    
    s = [stat statisticsDiscardingLowOutliers:0.2 high:0.0];
    XCTAssertEqualWithAccuracy([s mean], 20.0, 1e-6);
    
    s = [stat statisticsDiscardingLowOutliers:0.2 high:0.2];
    XCTAssertEqualWithAccuracy([s mean], 15.0, 1e-6);
}

@end
